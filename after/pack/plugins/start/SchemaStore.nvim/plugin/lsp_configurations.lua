vim.lsp.config('vscode_json_languageservice', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yaml_language_server', {
  settings = {
    yaml = {
      schemastore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})
