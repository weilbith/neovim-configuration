local icons = require('icons')

return {
  provider = function()
    ---@diagnostic disable-next-line: undefined-field
    local content = _G.dropbar()
    content = content:gsub('%%%*', '')
    content = content:gsub(icons.ChevronRight, '%%#WhiteBold#' .. icons.ChevronRight)
    return content
  end,
}
