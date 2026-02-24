--- The simple ist:
--- Enable LSP based folding when available and close certain fold like imports.
---
--- Why is it complicated?
--- The folding related options are set local to *window*. The support for LSP
--- folds is determined by the clients attached to a *buffer*.
--- When a buffer enters a window, it might not have a client attached yet. If
--- folding support via LSP is detected later, all windows displaying this buffer
--- need to update for using LSP based folding. The same the other way around
--- when clients should detach.
--- If the buffer is switched within the same window, the newly displayed buffer
--- might not have a LSP client with folding support attached. So the window
--- options need to be reverted again.

---@param buffer integer
---@return boolean
local function any_client_supports_folding(buffer)
  return #vim.lsp.get_clients({
    method = vim.lsp.protocol.Methods.textDocument_foldingRange,
    bufnr = buffer,
  }) > 0
end

---@param window integer
---@return nil
local function set_lsp_based_folding(window)
  vim.wo[window].foldmethod = 'expr'
  vim.wo[window].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  vim.wo[window].foldtext = ''
  -- vim.wo[window].foldtext = 'v:lua.vim.lsp.foldtext()' -- TODO: Break syntax highlighting.
end

--- This simply sets any relevant option for the window to `nil`. It does not
--- provide any logic to restore window local options set before LSP folding.
--- Global options will then take affect again.
--- The coordination with various different folding methods would be actually
--- complicated. Furthermore, the auto command would need to become smarter on
--- multiple client attachments etc.
---
---@param window integer
---@return nil
local function unset_lsp_based_folding(window)
  vim.wo[window].foldmethod = nil
  -- vim.wo[window].foldexpr = nil
  -- vim.wo[window].foldtext = nil
end

---@param buffer integer
---@return integer[] windows
local function find_windows_displaying_this_buffer(buffer)
  return vim
    .iter(vim.api.nvim_list_wins())
    :filter(function(window)
      return vim.api.nvim_win_get_buf(window) == buffer
    end)
    :totable()
end

local group = vim.api.nvim_create_augroup('plugin/lsp/folding.lua', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(arguments)
    if any_client_supports_folding(arguments.buf) then
      vim.iter(find_windows_displaying_this_buffer(arguments.buf)):each(function(window)
        set_lsp_based_folding(window)
        vim.lsp.foldclose('imports', window)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function(arguments)
    if not any_client_supports_folding(arguments.buf) then
      vim.iter(find_windows_displaying_this_buffer(arguments.buf)):each(unset_lsp_based_folding)
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = group,
  callback = function(arguments)
    if any_client_supports_folding(arguments.buf) then
      set_lsp_based_folding(vim.api.nvim_get_current_win())
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = group,
  callback = function()
    unset_lsp_based_folding(vim.api.nvim_get_current_win())
  end,
})
