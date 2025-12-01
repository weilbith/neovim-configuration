vim.cmd.packadd('nvim-treesitter')
vim.cmd.packadd('nvim-treesitter-textobjects')

require('hop').setup({
  winblend = 80,
})

-- TODO: set keys for WORKMAN keyboard layout
