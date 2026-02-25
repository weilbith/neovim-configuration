local cmp = require('blink.cmp')

vim.g.completion_menu_is_open_function = cmp.is_menu_visible

vim.g.completion_menu_entry_is_selected_function = function()
  return cmp.get_selected_item() ~= nil
end

vim.g.completion_menu_select_next_entry_function = cmp.select_next
vim.g.completion_menu_select_previous_entry_function = cmp.select_prev
vim.g.completion_menu_confirm_selected_entry_function = cmp.accept
vim.g.completion_menu_close_menu_function = cmp.cancel
