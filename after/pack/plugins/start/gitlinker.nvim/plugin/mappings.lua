require('plugin_manager').lazy_load_plugin_on_command('gitlinker.nvim', 'GitLink')

vim.keymap.set(
  'n',
  '<leader>gy',
  vim.cmd.GitLink,
  { desc = 'yank URL to line of code at cursor on remote repository (e.g. on GitHub)' }
)
