vim.lsp.on_type_formatting.enable()
vim.lsp.linked_editing_range.enable()

-- TODO: Why does this API work differently? All this just to change the `style`
local group = vim.api.nvim_create_augroup('Lsp/enable_features', {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  desc = 'enable LSP document colors with non default style',
  callback = function(arguments)
    local client = vim.lsp.get_client_by_id(arguments.data.client_id)

    if client ~= nil and client:supports_method('textDocument/documentColor') then
      vim.lsp.document_color.enable(true, arguments.buf, { style = 'virtual' })
    end
  end,
})
