--- @type vim.lsp.ClientConfig
return {
  cmd = { 'vale-ls' },
  filetypes = nil, -- ALL (let Vale configuration handle it)
  root_markers = { '.vale.ini' },
}
