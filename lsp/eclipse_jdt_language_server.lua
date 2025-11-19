--- @type vim.lsp.Config
return {
  cmd = { 'jdtls' },
  filetypes = { 'java' },
  root_markers = {
    'settings.gradle',
    'settings.gradle.kts',
    'build.gradle',
    'build.gradle.kts',
    'build.xml',
    'pom.xml',
  },
  settings = {
    java = {
      completion = {
        guessMethodArguments = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all',
        },
      },
      signatureHelp = {
        description = {
          enabled = true,
        },
      },
      referencesCodeLens = {
        enabled = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
    },
  },
  init_options = {
    jvm_args = {},
    os_config = vim.Nil,
  },
}
