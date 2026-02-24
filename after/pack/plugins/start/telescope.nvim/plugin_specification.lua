require('packer').use({
  'nvim-telescope/telescope.nvim',
  opt = true,
})

-- Dependencies
require('packer').use({ 'nvim-lua/plenary.nvim', opt = true })
require('packer').use({ 'nvim-tree/nvim-web-devicons', opt = true })
require('packer').use({ 'Marskey/telescope-sg', opt = true })
require('packer').use({ 'nvim-telescope/telescope-fzy-native.nvim', opt = true })
