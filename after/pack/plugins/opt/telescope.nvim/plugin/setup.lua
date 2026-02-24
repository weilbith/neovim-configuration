vim.cmd.packadd('plenary.nvim')
vim.cmd.packadd('nvim-web-devicons')

local function show_file_history(buffer_number)
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')

  local picker = state.get_current_picker(buffer_number)
  local entries = picker:get_multi_selection()
  local first_commit = entries[1].value
  local last_commit = entries[#entries].value
  local commit_range = last_commit .. '..' .. first_commit
  local arguments = '--reverse --range=' .. commit_range .. ' --reverse'

  actions.close(buffer_number)
  vim.cmd.DiffviewFileHistory(arguments)
end

local icons = require('icons')

require('telescope').setup({
  defaults = {
    prompt_prefix = ' ' .. icons.ChevronRight .. ' ',
    entry_prefix = '   ',
    selection_caret = ' ' .. icons.ChevronRight .. ' ',
    multi_icon = ' ' .. icons.CheckboxChecked .. ' ',
    prompt_title = '',
    results_title = '',
    file_ignore_patterns = { '%.fls', '%.fdb_latexmk' },
    borderchars = {
      prompt = {
        '▔',
        ' ',
        ' ',
        ' ',
        '▔',
        '▔',
        ' ',
        ' ',
      },
      results = {
        ' ',
        ' ',
        '▁',
        ' ',
        ' ',
        ' ',
        '▁',
        '▁',
      },
      preview = {
        '▔',
        ' ',
        '▁',
        ' ',
        '▔',
        '▔',
        '▁',
        '▁',
      },
    },
    sorting_strategy = 'ascending',
    path_display = {
      truncate = true,
    },
    cache_picker = {
      num_pickers = 5,
    },
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        width = { padding = 0 },
        height = { 0.5, min = 40, max = 60 },
      },
      cursor = {
        height = { 0.5, min = 5, max = 5 },
      },
    },
  },
  pickers = {
    find_files = {
      prompt_title = '',
      preview_title = '',
      entry_maker = require('custom.telescope.entry_maker').file_entry_maker,
    },
    git_commits = {
      mappings = {
        i = {
          ['d'] = show_file_history,
        },
      },
    },
    live_grep = {
      on_input_filter_cb = function(prompt)
        return { prompt = prompt:gsub('%s', '.*') }
      end,
    },
  },
  extensions = {
    ast_grep = {
      command = { 'ast-grep', '--json=stream' },
      grep_open_files = false,
    },
  },
})

vim.cmd.packadd('telescope-fzy-native.nvim')
require('telescope').load_extension('fzy_native')
