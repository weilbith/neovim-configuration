require('nvim-highlight-colors').setup({
  render = 'virtual',
  virtual_symbol = '',
  virtual_symbol_position = 'inline',
  enable_named_colors = false,
  enable_tailwind = false,
  -- Disable in advantage of native feature via LSP when available.
  exclude_buffer = function(buffer)
    local any_attached_client_provides_colors = vim
      .iter(vim.lsp.get_clients({ bufnr = buffer }))
      :find(function(client)
        return client:supports_method('textDocument/documentColor')
      end)

    return any_attached_client_provides_colors
  end,
})
