vim.keymap.set(
  'n',
  'gd',
  vim.lsp.buf.definition,
  { desc = 'jump to definition of target under cursor (LSP)' }
)
