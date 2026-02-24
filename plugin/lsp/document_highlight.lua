---@param buffer integer
---@return boolean
local function any_client_supports_document_highlighting(buffer)
  return #vim.lsp.get_clients({
    method = vim.lsp.protocol.Methods.textDocument_documentHighlight,
    bufnr = buffer,
  }) > 0
end

local group = vim.api.nvim_create_augroup('lsp/document_highlight', { clear = true })

---@param buffer integer
---@return nil
local function setup_automatic_document_highlighting(buffer)
  local is_buffer_already_set_up = vim.b[buffer].document_highlight_autocommand_ids ~= nil

  if not is_buffer_already_set_up then
    local active_id = vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = group,
      buffer = buffer,
      callback = vim.lsp.buf.document_highlight,
      desc = 'Highlight references or similar to the symbol under the cursor',
    })

    local deactivate_id = vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = buffer,
      callback = vim.lsp.buf.clear_references,
    })

    vim.b[buffer].document_highlight_autocommand_ids = { active_id, deactivate_id }
  end
end

---@param buffer integer
---@return nil
local function clear_automatic_document_highlighting(buffer)
  vim.iter(vim.b[buffer].document_highlight_autocommand_ids or {}):each(vim.api.nvim_del_autocmds)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(arguments)
    if any_client_supports_document_highlighting(arguments.buf) then
      setup_automatic_document_highlighting(arguments.buf)
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function(arguments)
    if not any_client_supports_document_highlighting(arguments.buf) then
      clear_automatic_document_highlighting(arguments.buf)
    end
  end,
})
