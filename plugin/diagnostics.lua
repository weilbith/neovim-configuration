local icons = require('icons')
local severity = vim.diagnostic.severity
local circular_numbers = { '❶', '❷', '❸', '❹', '❺', '❻', '❼', '❽', '❾' }

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
      [severity.ERROR] = icons.Error,
      [severity.WARN] = '',
      [severity.INFO] = '',
      [severity.HINT] = '󰍢',
    },
  },
  float = {
    border = 'single',
    header = '',
    anchor_bias = 'below',
    source = true,
    prefix = number_to_circular_number,
  },
})
