vim.keymap.set(
  'n',
  'z=',
  'ea<C-x><C-s>',
  { desc = 'fix spelling with completion menu for suggestions' }
)

vim.keymap.set('n', 'g.', function()
  vim.o.list = not vim.o.list
end, { desc = 'toggle list mode to show list characters' })

vim.keymap.set('n', 'ZQ', function()
  vim.cmd.quitall({ mods = { confirm = true } })
end, { desc = 'quit NeoVim and ask for unsafed changes' })

vim.keymap.set('x', '>', '>gv', { desc = 'shift right without loosing selection' })
vim.keymap.set('x', '<', '<gv', { desc = 'shift right without loosing selection' })
