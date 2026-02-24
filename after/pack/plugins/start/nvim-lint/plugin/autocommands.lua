require('plugin_manager').lazy_load_plugin_on_lua_module('nvim-lint', 'lint')

local group = vim.api.nvim_create_augroup('plugins/nvim-lint', {})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  once = true, -- Just for configuration before first linting.
  callback = function()
    require('lint').linters_by_ft = {
      rust = { 'clippy' },
    }
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  callback = function()
    require('lint').try_lint()
  end,
})
