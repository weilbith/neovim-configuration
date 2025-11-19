--- @type vim.lsp.Config
return {
  cmd = { 'cssmodules-language-server' },
  filetypes = { 'typescriptreact' },
  root_markers = { 'package.json' },
}

-- TODO: Start only when it makes sense.
-- local function containsAnyCSSModuleLoading()
--   return vim.api.nvim_buf_call(0, function()
--     return vim.fn.search('module.css')
--   end) > 0
-- end
--
