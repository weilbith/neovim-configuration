vim.api.nvim_create_autocmd('FileType', {
  callback = function(arguments)
    if not vim.treesitter.highlighter.active[arguments.buf] then
      pcall(vim.treesitter.start, arguments.buf)
    end
  end,
  desc = 'activate Tree-sitter based highlighting',
})
