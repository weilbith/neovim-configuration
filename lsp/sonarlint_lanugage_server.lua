--- @type vim.lsp.Config
return {
  cmd = {
    'sonarlint-ls',
    '-stdio',
    '-analyzers',
    '/usr/share/java/sonarlint-ls/analyzers/sonarjava.jar',
  },
  filetypes = { 'java', 'kotlin' },
  root_markers = { 'build.gradle', 'build.gradle.kts' },
}
