--- @type vim.lsp.Config
return {
  cmd = { 'deno', 'lsp' },
  filestypes = { 'typescript' },
  root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' },
  settings = {
    deno = {
      enable = true,
    },
  },
}
