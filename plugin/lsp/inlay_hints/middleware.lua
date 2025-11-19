local function indent_blankline_is_available()
  local loaded_successfully, _ = pcall(require, 'ibl')
  return loaded_successfully
end

local function get_active_scope_range(buffer_number)
  if indent_blankline_is_available() then
    local buffer_configuration = require('ibl.config').get_config(buffer_number)
    local scope = require('ibl.scope').get(buffer_number, buffer_configuration)

    if scope ~= nil then
      local start_line, _, end_line, _ = scope:range()
      return { start_line = start_line, end_line = end_line }
    end
  end
end

local function inlay_hint_is_in_range(inlay_hint, start_line, end_line)
  local hint_line = inlay_hint.position.line
  return hint_line >= start_line and hint_line <= end_line
end

--- Filter inlay hints based on current scope where cursor is in code. This
--- helps to remove the cluttering of too many inlay hints all over the place
--- and focuses them on the current piece of code where these hints might be
--- helpful.
--- Requires for more eager redrawing of inlay hints to take properly effect.
require('lsp.start.middleware').add_middleware(
  'textDocument/inlayHint',
  function(error, result, context, configuration)
    if #(result or {}) > 0 then
      local range = get_active_scope_range(context.bufnr)

      if range ~= nil then
        result = vim
          .iter(result or {})
          :filter(function(inlay_hint)
            return inlay_hint_is_in_range(inlay_hint, range.start_line, range.end_line)
          end)
          :totable()
      else
        result = {}
      end
    end

    return true, error, result, context, configuration
  end
)
