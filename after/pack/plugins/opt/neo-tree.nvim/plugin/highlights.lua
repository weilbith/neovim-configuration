vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker', { link = 'Grey' })
vim.api.nvim_set_hl(0, 'NeoTreeFileName', { link = 'White' })
vim.api.nvim_set_hl(0, 'NeoTreeFileNameOpened', { link = 'WhiteBold' })
vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon', { link = 'LightGrey' })
vim.api.nvim_set_hl(0, 'NeoTreeDirectoryName', { link = 'White' })

vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { link = 'VcsStatusModified' })
vim.api.nvim_set_hl(0, 'NeoTreeGitAdded', { link = 'VcsStatusAdded' })
vim.api.nvim_set_hl(0, 'NeoTreeGitDeleted', { link = 'VcsStatusDeleted' })
vim.api.nvim_set_hl(0, 'NeoTreeGitRenamed', { link = 'VcsStatusRenamed' })
vim.api.nvim_set_hl(0, 'NeoTreeGitConflict', { link = 'VcsStatusConflict' })
vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { link = 'VcsStatusUntracked' })
vim.api.nvim_set_hl(0, 'NeoTreeGitIgnored', { link = 'VcsStatusIgnored' })
vim.api.nvim_set_hl(0, 'NeoTreeGitStaged', { link = 'LightGrey' }) -- TODO: Is this an overlay?
vim.api.nvim_set_hl(0, 'NeoTreeGitUnstaged', { link = 'Normal' }) -- TODO: Is this an overlay?

vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { link = 'GreyBackground' })
vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorActive', { link = 'Grey' })
vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { link = 'DarkGreyBackground' })
vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorInactive', { link = 'DarkGrey' })
