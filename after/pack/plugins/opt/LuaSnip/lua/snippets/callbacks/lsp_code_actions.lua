local snippet_events = require('luasnip.util.events')
local code_action_method_name = require('vim.lsp.protocol').Methods.textDocument_codeAction

--- @param name string
--- @return table | nil client
local function get_client_with_name(name)
  return vim.lsp.get_clients({
    name = name,
    method = code_action_method_name,
  })[1]
end

---@param snippet_node table
---@return number line, number character
local function get_node_position(snippet_node)
  local start_position, _ = snippet_node:get_buf_position()
  local line, character = start_position[1], start_position[2]
  return line, character
end

--- @param client table
--- @param buffer number
--- @param line number
--- @param character number
--- @return fun(): table, table parameter_builder
local function get_request_parameter_builder(client, buffer, line, character)
  return function()
    local textDocument = vim.lsp.util.make_text_document_params(buffer)
    local correct_character = vim.lsp.util.character_offset(
      buffer,
      line,
      character,
      client.offset_encoding
    )
    local position = { line = line, character = correct_character }
    local range = { start = position, ['end'] = position }
    local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(buffer, line)
    local context = { diagnostics = diagnostics }
    local parameter = { textDocument = textDocument, range = range, context = context }
    return parameter, diagnostics
  end
end

--- @param title_pattern string
--- @return fun(code_action: table): boolean
local function get_code_action_matcher(title_pattern)
  return function(code_action)
    return code_action.title:match(title_pattern) ~= nil
  end
end

--- @param code_action table
--- @return nil
local function execute_code_action(client, code_action)
  if code_action.command ~= nil then
    vim.lsp.buf.execute_command(code_action.command)
  elseif code_action.edit ~= nil then
    vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
  end
end

--- @param client table
--- @param is_matching_code_action fun(code_action: table): boolean
--- @return fun(code_actions: table[]): boolean code_action_handler
local function get_code_action_handler(client, is_matching_code_action)
  return function(code_actions)
    local matching_code_action = vim.iter(code_actions):find(is_matching_code_action)

    if matching_code_action ~= nil then
      execute_code_action(client, matching_code_action)
      return true
    else
      return false
    end
  end
end

--- @class RetryOptions
--- @field maximum_retry_count number | nil (default 4)
--- @field retry_delay number | nil (default 200)
--- @field wait_for_diagnostics boolean | nil (default false)

--- @class RequestOptions
--- @field client table
--- @field method_name string
--- @field buffer number
--- @field build_parameter fun(): table, table to get request parameter and included diagnostics
--- @field try_handle_response fun(response: table): boolean indicates success in return value
--- @field retry_options RetryOptions

--- Abstract method that continues to make LSP requests until the passed request
--- handler reports a success or a cancel condition is reached. The latter
--- happens if a maximum number of retries have been reached or a potential
--- deadlock is suspected.
--- When the retry option is set to wait for diagnostics, retries happen without
--- the actual count to increase. This can be helpful for servers which need to
--- populate the diagnostic first (based on the snippet code) to be integrated
--- into the request back again.
---
--- TODO: Reduce/break down complexity.
---
--- @param options RequestOptions
--- @param retry_count number | nil set on recursive retry calls (default 0)
--- @param deadlock_count number | nil absolute recursive counter (default 0)
--- @return nil
local function request_client_with_retries(options, retry_count, deadlock_count)
  retry_count = retry_count or 0
  deadlock_count = deadlock_count or 0
  local maximum_retry_count = options.retry_options.maximum_retry_count or 4
  local in_deadlock = deadlock_count > 50
  local should_cancel = retry_count > maximum_retry_count or in_deadlock

  if should_cancel then
    return
  end

  local retry = function(new_retry_count)
    vim.defer_fn(function()
      request_client_with_retries(options, new_retry_count or retry_count, deadlock_count + 1)
    end, options.retry_options.retry_delay or 200)
  end

  local parameter, diagnostics = options.build_parameter()
  local wait_for_diagnostics = #diagnostics == 0
    and options.retry_options.wait_for_diagnostics == true

  if wait_for_diagnostics then
    retry()
  else
    local handle_response = function(_, result)
      local response_was_handled = options.try_handle_response(result)

      if not response_was_handled then
        retry(retry_count + 1)
      end
    end

    options.client:request(options.method_name, parameter, handle_response, options.buffer)
  end
end

--- @param snippet_node table
--- @param client_name string
--- @param title_pattern string
--- @param retry_options RetryOptions
--- @return nil
local function try_to_run_matching_code_action_at_nodes_position(
  snippet_node,
  client_name,
  title_pattern,
  retry_options
)
  local client = get_client_with_name(client_name)

  if client ~= nil then
    local buffer = vim.api.nvim_get_current_buf()
    local line, character = get_node_position(snippet_node)
    local build_parameter = get_request_parameter_builder(client, buffer, line, character)
    local is_matching_code_action = get_code_action_matcher(title_pattern)
    local try_handle_response = get_code_action_handler(client, is_matching_code_action)

    request_client_with_retries({
      client = client,
      method_name = code_action_method_name,
      buffer = buffer,
      build_parameter = build_parameter,
      try_handle_response = try_handle_response,
      retry_options = retry_options,
    })
  end
end

--- The created node options define an enter event callback function that will
--- immediately return, scheduling two pieces of functionality for immediate
--- execution. First is the core functionality to execute a potential LSP code
--- action. Second is a jump to the next node in the current snippet.
---
--- The code actions are requested via the specified LSP client. If the server
--- responds with a code action that has a matching title, it gets automatically
--- executed. As LSP synchronization can take a quick moment on different
--- levels, a retry mechanism is established to improve reliability.
--- Note that might be absolutely fine that there is no code action. For example
--- an automatic import only "works" for the first time, afterwards it is
--- already there.
---
--- The jump happens as result of a little workaround. To have the snippet
--- engine execute the callback, it must be a jumpable/indexed node in the
--- snippet. Plain text nodes for example do not work. Therefore jumpable nodes
--- must be used to have this callback work. To still have it act like
--- a non-interactive node, an immediate jump is triggered on behalf of the
--- user, leading to an basically seamless user experience. The code action
--- might happen noticeably later.
--- Unfortunately does this mean that backwards jumping in snippet across such
--- a node does not work anymore.
---
--- Finally this also removes node markers for these nodes as they should appear
--- as non interactive.
---
--- @param client_name string name of LSP server client to request
--- @param title_pattern string to filter code actions for a match
--- @param retry_options RetryOptions | nil for case specific optimization
--- @return table node_options
local function get_node_options_with_lsp_code_action_callback(
  client_name,
  title_pattern,
  retry_options
)
  local code_action_callback = function(snippet_node)
    vim.defer_fn(function()
      try_to_run_matching_code_action_at_nodes_position(
        snippet_node,
        client_name,
        title_pattern,
        retry_options or {}
      )
    end, 0)

    vim.defer_fn(function()
      require('luasnip').jump(1)
    end, 0)
  end

  local node_callbacks = {
    [snippet_events.enter] = code_action_callback,
  }

  local neutral_marker_options = {
    virt_text = { { '' } },
    hl_group = '',
  }

  local node_marker_options = {
    visited = neutral_marker_options,
    unvisited = neutral_marker_options,
    active = neutral_marker_options,
  }

  return { node_callbacks = node_callbacks, node_ext_opts = node_marker_options }
end

return {
  get_node_options_with_lsp_code_action_callback = get_node_options_with_lsp_code_action_callback,
}
