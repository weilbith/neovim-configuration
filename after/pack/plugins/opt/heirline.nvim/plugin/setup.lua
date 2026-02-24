local buffer_matches = require('heirline.conditions').buffer_matches
local Breadcrumbs = require('heirline_custom.components.breadcumbs')
local Tests = require('heirline_custom.components.tests')
local Signs = require('heirline_custom.components.signs')
local Folds = require('heirline_custom.components.folds')
local LineNumber = require('heirline_custom.components.line_number')
local Border = require('heirline_custom.components.border')

local Space = { provider = ' ' }
local Gap = { provider = '%=' }

local window_bar = { Space, Breadcrumbs, Gap, Tests, Space }
local status_column = { Space, LineNumber, Space, Border, Folds, Signs }

require('heirline').setup({
  winbar = window_bar,
  statuscolumn = status_column,
  opts = {
    disable_winbar_cb = function(args)
      local has_no_filetype = vim.bo[args.buf].ft == ''
      local buffer_is_listed = vim.bo[args.buf].buflisted
      local is_special_listed_buffer = buffer_is_listed
        and buffer_matches({ buftype = { 'help', 'quickfix' } }, args.buf)
      local is_special_unlisted_buffer = not buffer_is_listed
        and not buffer_matches({ filetype = { 'dapui*' } }, args.buf)

      return has_no_filetype or is_special_listed_buffer or is_special_unlisted_buffer
    end,
  },
})
