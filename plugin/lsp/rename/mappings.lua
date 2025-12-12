vim.keymap.set('n', 'grN', function()
  local new_name = vim.fn.expand('<cword>')
  vim.cmd.undo({ bang = true })
  vim.lsp.buf.rename(new_name)
end, {
  desc = 'apply forgotten symbol rename for last text edit',
})
