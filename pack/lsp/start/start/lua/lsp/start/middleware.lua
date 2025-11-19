local ALL_FILE_TYPES = 'all-file-types'

--- @alias FileType string
--- @alias MethodName vim.lsp.protocol.Methods
--- @alias ResponseHandler fun(error?: lsp.ResponseError, result: any, context: lsp.HandlerContext, configuration?: table)
--- @alias MiddlewareReponseHandler fun(continue: boolean, error?: lsp.ResponseError, result: any, context: lsp.HandlerContext)

--- @class HandlerWithPriority
--- @field handler MiddlewareReponseHandler
--- @field priority integer

--- @type { [FileType]: { [MethodName]: HandlerWithPriority[] } }
local storage = {}

--- @param method_name MethodName - protocol method to add handler for
--- @param handler MiddlewareReponseHandler - handler to add on middleware stack for this method
--- @param priority integer? - used to sort handlers in the middleware stack on execution
--- @param file_type FileType? - apply configuration for this file type only, all by default
---
--- A middleware handle function must return a list of values:
---   - A boolean value that decided if the client should continue processing the
---     servers response down the middleware stack.
---   - The server response properties in the order of error, response, context,
---     configuration. This can be used to manipulate the response for the next
---     middleware handler in the stack.
local function add_middleware(method_name, handler, priority, file_type)
  vim.validate({ handler = { handler, 'function', false } })

  file_type = file_type or ALL_FILE_TYPES
  priority = priority or 1

  if storage[file_type] == nil then
    storage[file_type] = {}
  end

  local handler_list = storage[file_type][method_name] or {}
  --- @type HandlerWithPriority
  local handler_entry = { handler = handler, priority = priority }
  table.insert(handler_list, handler_entry)
  storage[file_type][method_name] = handler_list
end

--- @param method_name MethodName - protocol method add handler for
--- @param file_type FileType - apply configuration for this file type only
--- @return table[function]
---
--- Collects all handler functions for the specified method and sorts them based
--- on their priority, with highest priority first. Merges handlers registered
--- for all file types with those for the specified one.
local function get_middleware_stack(method_name, file_type)
  local all_filetype_handlers = (storage[ALL_FILE_TYPES] or {})[method_name] or {}
  local language_specific_handlers = (storage[file_type] or {})[method_name] or {}

  local all_handlers = vim.list_extend(all_filetype_handlers, language_specific_handlers)
  table.sort(all_handlers, function(a, b)
    return a.priority > b.priority
  end)

  local middleware_stack = vim
    .iter(all_handlers)
    :map(function(entry)
      return entry.handler
    end)
    :totable()

  return middleware_stack
end

--- @param method_name MethodName - protocol method to get handler for
--- @param file_type FileType - apply configuration for this file type only
--- @param base_handler ResponseHandler? - handler external to middleware or NeoVim default
--- @return ResponseHandler?
local function get_client_response_handler_for_method(method_name, file_type, base_handler)
  return function(error, result, context, configuration)
    local middleware_stack = get_middleware_stack(method_name, file_type)
    local continue = true

    for _, next_handler in ipairs(middleware_stack or {}) do
      if continue then
        continue, error, result, context, configuration =
          next_handler(error, result, context, configuration)
      end
    end

    if base_handler ~= nil then
      base_handler(error, result, context, configuration)
    end

    local default_handler = vim.lsp.handlers[method_name]

    -- Always call default handler if exists, because the "special" return
    -- values matter to NeoVim.
    if default_handler ~= nil then
      return default_handler(error, result, context, configuration)
    end
  end
end

--- @param file_type FileType configuration for this file type only
--- @param base_handlers { [MethodName]: ResponseHandler } set of existing handlers to mix with middleware
--- @return { [MethodName]: ResponseHandler }
local function get_client_response_handlers(file_type, base_handlers)
  return setmetatable({}, {
    --- @param method_name MethodName
    --- @return ResponseHandler?
    __index = function(_, method_name)
      local base_handler = (base_handlers or {})[method_name]
      return get_client_response_handler_for_method(method_name, file_type, base_handler)
    end,
  })
end

return {
  add_middleware = add_middleware,
  get_middleware_stack = get_middleware_stack,
  get_client_response_handlers = get_client_response_handlers,
}
