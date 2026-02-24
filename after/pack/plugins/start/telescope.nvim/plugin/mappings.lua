require('plugin_manager').lazy_load_plugin_on_command('telescope.nvim', 'Telescope')

vim.keymap.set('n', '<leader>ff', function()
  vim.cmd.Telescope('find_files')
end, { desc = 'search for files in fuzzy finder' })

vim.keymap.set('n', '<leader>bb', function()
  vim.cmd.Telescope('buffers')
end, { desc = 'search for buffers in fuzzy finder' })

vim.keymap.set('n', '<leader>ss', function()
  vim.cmd.Telescope('ast_grep')
end, { desc = 'structural, syntax aware text pattern search' })

vim.keymap.set('n', '<leader>sS', function()
  vim.cmd.Telescope('live_grep')
end, { desc = 'search for text ("grep") in fuzzy finder' })

vim.keymap.set('n', '<leader>sw', function()
  vim.cmd.Telescope('grep_string')
end, { desc = 'search for word under cursor in fuzzy finder' })

vim.keymap.set('n', '<leader>sr', function()
  vim.cmd.Telescope('resume')
end, { desc = 'resume last search in fuzzy finder' })

vim.keymap.set('n', '<leader>sR', function()
  vim.cmd.Telescope('pickers')
end, { desc = 'list of last fuzzy finder sessions' })

vim.keymap.set('n', '<leader>gl', function()
  vim.cmd.Telescope('git_commits')
end, { desc = 'list git commits with preview information' })

vim.keymap.set('n', '<leader>ql', function()
  vim.cmd.Telescope('quickfixhistory')
end, { desc = 'list history of quickfix lists' })

vim.keymap.set('c', 'he', function()
  local is_ex_command = vim.fn.getcmdtype() == ':'
  local is_at_start_of_command_line = vim.fn.getcmdpos() == 1
  local should_open_finder_for_help_tags = is_ex_command and is_at_start_of_command_line
  return should_open_finder_for_help_tags and 'Telescope help_tags<CR>' or 'he'
end, {
  expr = true,
  noremap = true,
  desc = "quickly open fuzzy finder for help tags when trying to trigger ':help'",
})
