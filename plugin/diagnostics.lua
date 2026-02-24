local namespace_for_virtual_line_diagnostics = vim.api.nvim_create_namespace('lsp/diagnostic')

---@param diagnostic? vim.Diagnostic
---@param buffer integer
local function show_diagnostic_on_jump(diagnostic, buffer)
  if diagnostic ~= nil then
    vim.diagnostic.show(
      namespace_for_virtual_line_diagnostics,
      buffer,
      { diagnostic },
      { virtual_lines = { current_line = true }, virtual_text = false }
    )
  end
end

vim.diagnostic.config({
  update_in_insert = true,
  severity_sort = true,
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require('icons').Error,
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰍢',
    },
  },
  jump = { on_jump = show_diagnostic_on_jump },
  float = {
    border = 'single',
    header = '',
    anchor_bias = 'below',
    source = true,
  },
})

local group = vim.api.nvim_create_augroup('diagnostics', { clear = true })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = group,
  callback = function(args)
    -- TODO: Only hide, if diagnostics that have been shown changed.
    vim.diagnostic.hide(namespace_for_virtual_line_diagnostics, args.buf)
  end,
  desc = 'Fix dangling virtual line diagnostics that have been shown, but diagnostics changed due to editing/fixing them',
})
