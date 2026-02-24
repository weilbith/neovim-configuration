vim.loader.enable()

vim.cmd.filetype('plugin', 'on')
vim.cmd.filetype('indent', 'on')
vim.cmd.syntax('on')

vim.opt.encoding = 'utf-8'
vim.opt.spell = true
vim.opt.spelloptions = 'camel'
vim.opt.spellfile = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.opt.spelllang = { 'en', 'de' }
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'c'
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.formatoptions = 'j1cql'
vim.opt.textwidth = 80
vim.opt.linebreak = true
vim.opt.whichwrap = 'b,s,h,l'
vim.opt.showmode = false
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append('c')
vim.opt.showmatch = true
vim.opt.scrolloff = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 1000
vim.opt.updatecount = 0
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = '0'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
vim.opt.signcolumn = 'yes:1'
vim.opt.hidden = true
vim.opt.pumheight = 30
vim.opt.joinspaces = false
vim.opt.inccommand = 'split'
vim.opt.fillchars = {
  diff = '╱',
  fold = ' ',
  foldclose = '',
  foldopen = '',
  foldsep = '│',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
  stl = ' ',
  stlnc = ' ',
}
vim.opt.listchars = {
  eol = '󰌑',
  tab = '󰌒󰌒',
  space = '.',
  nbsp = '.',
  trail = '.',
  extends = '󰇘',
  precedes = ' ',
}
vim.opt.diffopt = 'internal,filler,closeoff,vertical,context:3,algorithm:patience'
vim.opt.viewoptions = { 'cursor', 'folds' }
vim.opt.laststatus = 0
vim.opt.statusline = string.rep(vim.opt.fillchars:get().horiz, vim.api.nvim_win_get_width(0))
vim.opt.cmdheight = 1
vim.opt.splitkeep = 'screen'
vim.opt.exrc = true
vim.opt.mousemoveevent = true
