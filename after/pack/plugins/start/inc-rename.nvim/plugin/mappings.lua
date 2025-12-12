require('plugin_manager').lazy_load_plugin_on_command('inc-rename.nvim', 'IncRename')

vim.keymap.set('n', 'grN', function()
  local current_name = vim.fn.expand('<cword>')
  local _, error = pcall(vim.cmd.IncRename, current_name)

  if error then
    vim.lsp.buf.rename()
  end
end, { desc = 'rename target under cursor with preview' })
