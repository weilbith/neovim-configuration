require('conform').setup({
  formatters_by_ft = {
    kotlin = { 'ktfmt' },
    lua = { 'stylua' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    rust = { lsp_format = 'first' },
  },
  default_format_ops = {
    lsp_format = 'first',
    filter = function(client)
      -- Causes issues in combination with Prettier formatting.
      -- Disabling formatting on server configuration causes issues in conform.
      return client.name ~= 'vtsls'
    end,
  },
})
