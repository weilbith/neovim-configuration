--- @type vim.lsp.Config
return {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = { { 'pyproject.toml', 'setup.py' } },
  settings = {
    pyls = {
      plugins = {
        pycodestyle = {
          enabled = false,
        },
        pyls_mypy = {
          enabled = true,
        },
      },
    },
  },
}
