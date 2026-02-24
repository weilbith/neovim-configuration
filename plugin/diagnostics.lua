local namespace = vim.api.nvim_create_namespace('lsp/diagnostic')

local function number_to_circular_number(_, index)
  return (circular_numbers[index] or index) .. ' '
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
  float = {
    border = 'single',
    header = '',
    anchor_bias = 'below',
    source = true,
  },
})
