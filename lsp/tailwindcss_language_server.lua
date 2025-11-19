--- @type vim.lsp.Config
return {
  cmd = { 'tailwindcss-language-server' },
  filetypes = { 'css', 'vue', 'typescriptreact' },
  -- TODO: Add support for ^v4.0.0
  root_markers = { 'tailwind.config.ts', 'tailwind.config.js' },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        rust = 'html',
      },
    },
  },
}
