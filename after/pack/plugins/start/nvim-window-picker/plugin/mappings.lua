require('plugin_manager').lazy_load_plugin_on_lua_module('nvim-window-picker', 'window-picker')

vim.keymap.set('n', '<leader>ww', function()
  local window = require('window-picker').pick_window()
  vim.api.nvim_set_current_win(window)
end, { desc = 'show markers in all windows to pick from' })
