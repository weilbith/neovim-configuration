--- The default key bindings to "in" and "an" don't work well for me.

vim.keymap.set('v', '.', function()
  vim.lsp.buf.selection_range(1)
end, {})

vim.keymap.set('v', ',', function()
  vim.lsp.buf.selection_range(-1)
end, {})
