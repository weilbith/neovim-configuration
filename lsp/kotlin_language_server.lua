--- @type vim.lsp.Config
return {
  cmd = { 'kotlin-language-server' },
  filetypes = { 'kotlin' },
  root_markers = {
    'settings.gradle',
    'settings.gradle.kts',
    'build.gradle',
    'build.gradle.kts',
    'build.xml',
    'pom.xml',
  },
  init_options = {
    storagePath = vim.fs.root(0, '.git') or vim.NIL,
  },
  settings = {
    externalSources = {
      autoConvertToKotlin = true,
    },
    hints = {
      typeHints = true,
      parameterHints = true,
      chainedHints = true,
    },
  },
}
