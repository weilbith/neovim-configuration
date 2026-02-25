-- For unknown reasons, without deferring the highlights don't get applied.
vim.schedule(function()
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { link = 'Bold' })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { link = 'LightGrey' })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { link = 'Italic' })
  vim.api.nvim_set_hl(
    0,
    'BlinkCmpLabelDeprecated',
    { foreground = '#808080', strikethrough = true }
  )
end)
