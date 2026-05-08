local function is_fold_start()
  return vim.v.virtnum == 0 and vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1)
end

local function fold_is_open()
  return vim.fn.foldclosed(vim.v.lnum) == -1
end

local function is_wrapped_line()
  return vim.v.virtnum > 0
end

-- TODO: Figure out if line is in currently open fold and highlight it plus | character
return {
  provider = function()
    if is_wrapped_line() or not is_fold_start() then
      return ' '
    elseif fold_is_open() then
      return vim.opt.fillchars:get().foldopen
    else
      return vim.opt.fillchars:get().foldclose
    end
  end,
  hl = 'Grey',
}
