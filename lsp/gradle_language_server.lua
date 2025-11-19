--- @type vim.lsp.Config
return {
  cmd = { 'gradle-language-server' },
  filetypes = { 'groovy' },
  root_markers = { 'settings.gradle', 'build.gradle' },
  init_options = {
    settings = {
      gradleWrapperEnabled = true,
    },
  },
}
