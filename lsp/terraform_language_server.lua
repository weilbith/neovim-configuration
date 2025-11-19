--- @type vim.lsp.Config
return {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform' },
  root_markers = { '.terraform' },
}
