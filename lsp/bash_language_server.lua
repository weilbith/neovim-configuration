--- @type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'zsh' },
  root_markers = { '.git' },
}
