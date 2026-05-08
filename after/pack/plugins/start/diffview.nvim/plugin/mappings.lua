require('plugin_manager').lazy_load_plugin_on_command(
  'diffview.nvim',
  { 'DiffviewOpen', 'DiffviewFileHistory' }
)

vim.keymap.set(
  'n',
  '<leader>ga',
  vim.cmd.DiffviewOpen,
  { desc = 'open interface for git staging area to add files' }
)

vim.keymap.set(
  'n',
  '<leader>gd',
  vim.cmd.DiffviewFileHistory,
  { desc = 'open interface to inspect git history in diff mode' }
)

vim.keymap.set('n', '<leader>gdf', function()
  vim.cmd.DiffviewFileHistory('%')
end, { desc = 'open interface to inspect git history in diff mode for current file only' })

vim.keymap.set('n', '<leader>glf', function()
  local function_name = vim.fn.expand('<cword>')
  local file_path = vim.fn.expand('%:p')
  local arguments = string.format('-L:%s:%s', function_name, file_path)
  vim.cmd.DiffviewFileHistory(arguments)
end, { desc = 'open interface to inspect git history in diff mode for current function' })
