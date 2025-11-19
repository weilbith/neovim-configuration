vim.cmd.packadd('nvim-web-devicons')

local icons = require('icons')

require('dropbar').setup({
  icons = {
    symbols = vim
      .iter(icons.LSP.symbol_kind)
      :map(function(symbol_kind)
        return { icon = symbol_kind.icon, hl = symbol_kind.highlight }
      end)
      :totable(),
    ui = {
      bar = {
        separator = ' ' .. icons.ChevronRight .. ' ',
      },
      menu = {
        indicator = icons.ChevronRight,
      },
    },
  },
  bar = {
    enable = false, -- Rather embed this manually into separated winbar plugin.
    padding = {
      left = 0,
      right = 0,
    },
  },
})
