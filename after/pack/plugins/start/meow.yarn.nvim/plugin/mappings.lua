require('plugin_manager').lazy_load_plugin_on_command('meow.yarn.nvim', 'MeowYarn')

vim.keymap.set('n', '<leader>cc', function()
  vim.cmd.MeowYarn({ args = { 'call', 'callers' } })
end, { desc = 'open interactive tree with call hierarchy of functions' })
