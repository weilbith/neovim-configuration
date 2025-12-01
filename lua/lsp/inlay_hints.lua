local group_identifier = vim.api.nvim_create_augroup('InlayHints', {})

--- @param buffer? number
--- @return boolean
local function inlay_hints_are_supported(buffer)
  local clients_with_support = vim.lsp.get_clients({
    method = vim.lsp.protocol.Methods.textDocument_inlayHint,
    bufnr = buffer or 0,
  })
  return #clients_with_support > 0
end

local function create_auto_commands()
  vim.api.nvim_create_autocmd({ 'LspAttach', 'InsertLeave' }, {
    group = group_identifier,
    callback = function(arguments)
      if inlay_hints_are_supported(arguments.buf) then
        vim.lsp.inlay_hint.enable(true, { bufnr = arguments.buf })
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = group_identifier,
    callback = function(arguments)
      if inlay_hints_are_supported(arguments.buf) then
        vim.lsp.inlay_hint.enable(false, { bufnr = arguments.buf })
      end
    end,
  })

  -- UUUUGLY workaround to redraw hints based on filtering.
  -- Inlay hints get only redrawn if the buffer version has changed since last
  -- time. This gets reset when toggling as the state is cleared.
  -- TODO: avoid flickering within same section...
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    group = group_identifier,
    callback = function(arguments)
      if vim.lsp.inlay_hint.is_enabled({ bufnr = arguments.buf }) then
        vim.lsp.inlay_hint.enable(false, { bufnr = arguments.buf })
        vim.lsp.inlay_hint.enable(true, { bufnr = arguments.buf })
      end
    end,
  })
end

local function clear_auto_commands()
  vim.api.nvim_clear_autocmds({ group = group_identifier })
end

--- Toggles inlay hints on or off. Applies locally for a specific buffer only
--- if specified, else globally for all buffers.
---
--- @param buffer? number
--- @return boolean if inlay hints are now on or off
local function toggle(buffer)
  local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
  local is_enabled_now = not is_enabled

  if is_enabled_now then
    create_auto_commands()
  else
    clear_auto_commands()
  end

  vim.lsp.inlay_hint.enable(is_enabled_now, { bufnr = buffer })
  return is_enabled_now
end

return {
  create_auto_commands = create_auto_commands,
  toggle = toggle,
}
