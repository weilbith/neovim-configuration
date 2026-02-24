--- @type vim.lsp.Config
return {
  cmd = { 'deno', 'lsp' },
  filetypes = { 'typescript' },
  root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' },
  settings = {
    deno = {
      enable = true,
    },
  },
}
