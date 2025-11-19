--- @type vim.lsp.Config
return {
  cmd = { 'cucumber-language-server', '--stdio' },
  filetypes = { 'cucumber' },
  root_markers = { '.git' },
}
