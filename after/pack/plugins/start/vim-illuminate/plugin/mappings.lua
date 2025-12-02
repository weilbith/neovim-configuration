require('plugin_manager').lazy_load_plugin_on_lua_module('vim-illuminate', 'illuminate')

vim.keymap.set('n', ']r', function()
  require('illuminate').goto_next_reference()
end, { desc = 'go to next usage of target under cursor' })

vim.keymap.set('n', '[r', function()
  require('illuminate').goto_prev_reference()
end, { desc = 'go to previous usage of target under cursor' })
