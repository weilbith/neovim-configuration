---@type vim.lsp.Config
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = nil, -- ALL
  root_markers = { '.harper-dictionary.txt', '.git' },
}
