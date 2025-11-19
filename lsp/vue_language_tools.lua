--- @type vim.lsp.Config
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  init_options = {
    typescript = {
      tsdk = vim.fs.joinpath(vim.fs.root(0, 'node_modules') or '', '/node_modules/typescript/lib'),
    },
  },
}
