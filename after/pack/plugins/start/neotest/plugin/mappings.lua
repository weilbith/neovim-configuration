require('plugin_manager').lazy_load_plugin_on_command('neotest', 'Neotest')
require('plugin_manager').lazy_load_plugin_on_lua_module('neotest', 'neotest')

vim.keymap.set('n', '<localleader>tn', function()
  vim.cmd.Neotest('run')
end, { desc = 'run test case at cursor' })

vim.keymap.set('n', '<localleader>tl', function()
  vim.cmd.Neotest('run last')
end, { desc = 're-run last test case again' })

vim.keymap.set('n', '<localleader>td', function()
  vim.cmd.Neotest('run strategy=dap')
end, { desc = 'run test case at cursor in debug mode' })

vim.keymap.set('n', '<localleader>tf', function()
  vim.cmd.Neotest('run file')
end, { desc = 'run all test case in current file' })

vim.keymap.set('n', '<localleader>ta', function()
  vim.cmd.Neotest('attach')
end, { desc = 'attach to the current test run and observe logs' })

vim.keymap.set('n', '<localleader>to', function()
  vim.cmd.Neotest('output')
end, { desc = 'open the output of the (failed) test case at cursor' })

vim.keymap.set('n', '<localleader>tc', function()
  vim.cmd.Neotest('stop')
end, { desc = 'cancel execution of running tests' })

vim.keymap.set('n', '<localleader>ts', function()
  vim.cmd.Neotest('summary toggle')
end, { desc = 'toggle overview of test tree' })

vim.keymap.set('n', '<localleader>tA', function()
  require('neotest').playwright.attachment()
end, { desc = 'open list of attachments of Playwright test case' })

vim.keymap.set('n', ']t', function()
  vim.cmd.Neotest('jump next')
end, { desc = 'jump to next test case from cursor location' })
vim.keymap.set('n', '[t', function()
  vim.cmd.Neotest('jump prev')
end, { desc = 'jump to previous test case from cursor location' })

vim.keymap.set('n', ']T', function()
  vim.cmd.Neotest('jump next status=failed')
end, { desc = 'jump to next failed test case from cursor location' })

vim.keymap.set('n', '[T', function()
  vim.cmd.Neotest('jump prev status=failed')
end, { desc = 'jump to previous failed test case from cursor location' })
