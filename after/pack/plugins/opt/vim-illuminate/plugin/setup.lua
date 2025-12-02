require('illuminate').configure({
  providers = { 'lsp', 'treesitter' },
  under_cursor = false,
  filetypes_denylist = { 'NeogitStatus' },
})
