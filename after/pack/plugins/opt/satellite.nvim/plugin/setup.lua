require('satellite').setup({
  current_only = true,
  winblend = 0,
  handlers = {
    cursor = {
      enable = false,
    },
    diagnostic = {
      signs = { '▂' },
    },
    gitsigns = {
      signs = {
        add = '┃',
        change = '┃',
        delete = '┃',
      },
    },
  },
  excluded_filetypes = {
    'neo-tree',
    'DressingInput',
    'Glance',
  },
})
