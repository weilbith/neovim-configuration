local group = vim.api.nvim_create_augroup('CodeLens', {})

vim.api.nvim_create_autocmd({ 'LspAttach', 'InsertLeave' }, {
  group = group,
  callback = function(arguments)
    vim.lsp.codelens.refresh({ bufnr = arguments.buf })
  end,
})
