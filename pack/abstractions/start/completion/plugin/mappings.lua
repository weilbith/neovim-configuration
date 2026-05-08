local completion_menu = require('completion.menu')

--- @param keys string
--- @param mode string | nil - mode according to `:help feedkeys`
local function escape_and_feed_keys(keys, mode)
  local escaped_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(escaped_keys, mode, false)
end

vim.keymap.set({ 'i', 'c', 's' }, '<CR>', function()
  if completion_menu.is_open_and_entry_selected() then
    completion_menu.confirm_selected_entry()
  else
    escape_and_feed_keys('<CR>', 'n')
  end
end, {
  desc = 'confirm selected entry if completion menu is open, else normal <CR>',
})

vim.keymap.set({ 'i', 'c', 's' }, '<Tab>', function()
  if completion_menu.is_open() then
    completion_menu.select_next_entry()
  else
    escape_and_feed_keys('<Tab>', 'n')
  end
end, {
  desc = 'select next entry if completion menu is open, else normal <Tab>',
})

vim.keymap.set({ 'i', 'c', 's' }, '<A-Tab>', function()
  if not completion_menu.is_open() then
    completion_menu.open()
  else
    escape_and_feed_keys('<A-Tab>', 'n')
  end
end, {
  desc = 'manually open completion - for example without automatic trigger',
})

vim.keymap.set({ 'i', 'c', 's' }, '<S-Tab>', function()
  if completion_menu.is_open() then
    completion_menu.select_previous_entry()
  else
    escape_and_feed_keys('<S-Tab>', 'n')
  end
end, {
  desc = 'select previous entry if completion menu is open, else normal <S-Tab>',
})

vim.keymap.set({ 'i', 'c', 's' }, '<C-e>', function()
  if completion_menu.is_open() then
    completion_menu.close_menu()
  else
    escape_and_feed_keys('<C-e>', 'n')
  end
end, {
  desc = 'close completion menu if open, else normal control <C-e>',
})
