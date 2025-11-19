--- @type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    {
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
    },
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          'vim',
          -- Busted - why does it not pick it up from the library?
          'insulate',
          'describe',
          'it',
          'assert',
        },
      },
      runtime = {
        path = { '?.lua', '?/init.lua' },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
        setType = true,
      },
      IntelliSense = {
        traceLocalSet = true,
        traceReturn = true,
        traceBeSetted = true,
        traceFieldInject = true,
      },
      completion = {
        callSnippet = 'Both',
        keywordSnippet = 'Both',
        showParams = false,
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      type = {
        strict = true,
        checkTableShape = true,
      },
    },
  },
}
