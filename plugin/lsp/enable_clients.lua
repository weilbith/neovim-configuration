--- @see enable_all_clients_with_installed_server
--- @see start_to_notify_about_missing_server_installations

--- List of client names based on LSP configuration files in the runtime path.
--- See `:help lsp-new-config`
---
--- @return string[] client_names
local function get_list_of_client_names()
  return vim
    .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
    :map(function(path)
      return vim.fn.fnamemodify(path, ':t:r')
    end)
    :totable()
end

--- Checks if the configured server command for a client is executable.
--- This makes the assumption, that the first entry in the command argument list
--- is the executable. If there should be any "fancy" commands, this does not
--- work as expected.
---
--- @param client_name string
--- @return boolean is_executable
local function can_server_of_client_be_started(client_name)
  local configuration = vim.lsp.config[client_name] or {}
  local command = configuration.cmd or {}
  return #command > 0 and vim.fn.executable(command[1]) == 1
end

--- Simply checks the configuration of a client to determine if it would
--- theoretically start for a specific filetype.
---
---@param client_name string
---@param filetype string
---@return boolean
local function has_client_support_for_filetype(client_name, filetype)
  local supported_filetypes = (vim.lsp.config[client_name] or {}).filetypes
  return supported_filetypes == nil or vim.list_contains(supported_filetypes, filetype)
end

--- Automatically enable configured clients that can be used.
---
--- This makes use of LSP configuration files, available for all language
--- servers of personal use, but only enable those which are available in the
--- currently active development environment. It allows keeping configuration
--- files cleanly organized and avoid errors by Neovim for unavailable servers.
---
--- @return nil
local function enable_all_clients_with_installed_server()
  vim.iter(get_list_of_client_names()):filter(can_server_of_client_be_started):each(vim.lsp.enable)
end

--- Support to recognize if a client can't be used because it's server is not
--- installed. This complements the approach to have many clients configured,
--- but only activate those available. It might be hint that the current
--- development environment lacks some installation.
---
--- @return nil
local function start_to_notify_about_missing_server_installations()
  local group = vim.api.nvim_create_augroup(
    'plugin/lsp/enable_clients/notify_about_missing_server_installations',
    {}
  )

  ---@param filetype string
  ---@return fun(client_name: string): boolean
  local function has_support_for_filetype_but_missing_server_installation(filetype)
    ---@param client_name string
    return function(client_name)
      return has_client_support_for_filetype(client_name, filetype)
        and not can_server_of_client_be_started(client_name)
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(arguments)
      local is_buffer_listed = vim.bo[arguments.buf].buflisted

      if is_buffer_listed then
        local clients_names_with_missing_server = vim
          .iter(get_list_of_client_names())
          :filter(has_support_for_filetype_but_missing_server_installation(arguments.match))
          :join(', ')

        vim.schedule(function() -- do not block UI
          vim.notify('Missing server installations for: ' .. clients_names_with_missing_server)
        end)
      end
    end,
    desc = 'Notify about missing server installation for client of matching filetype.',
  })
end

enable_all_clients_with_installed_server()
start_to_notify_about_missing_server_installations()
