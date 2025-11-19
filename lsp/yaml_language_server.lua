--- @type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { '.git' },
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = true
  end,
}
