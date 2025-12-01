--- @param buffer? number
--- @return boolean
local function does_any_client_support_formatting(buffer)
  local clients_with_support = vim.lsp.get_clients({
    method = vim.lsp.protocol.Methods.textDocument_formatting,
    bufnr = buffer or 0,
  })
  return #clients_with_support > 0
end

--- @param buffer? number
local function format_with_language_client(buffer)
  if does_any_client_support_formatting(buffer) then -- Avoid disturbing warning messages.
    vim.lsp.buf.format({ bufnr = buffer, async = false })
  end
end

--- @param buffer number
local function format_buffer(buffer)
  if type(vim.g.format_buffer_function) == 'function' then
    vim.g.format_buffer_function(buffer)
  else
    format_with_language_client(buffer)
  end
end

return {
  format_buffer = format_buffer,
}
