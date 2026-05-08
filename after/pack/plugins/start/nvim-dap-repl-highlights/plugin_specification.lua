require('packer').use({
  'LiadOz/nvim-dap-repl-highlights',
  opt = true,
  run = function()
    require('nvim-dap-repl-highlights').setup()
    vim.packadd('nvim-treesitter')
    require('nvim-treesitter').install({ 'dap_repl' })
  end,
})

-- Dependencies
require('packer').use({ 'nvim-treesitter/nvim-treesitter', opt = true })
