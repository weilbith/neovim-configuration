---@type vim.lsp.Config
return {
  cmd = { 'codebook-lsp', 'serve' },
  filetypes = nil, -- ALL
  root_markers = { 'codebook.toml', '.codebook.toml', '.git' },
}
