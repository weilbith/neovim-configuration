local icons = require('icons').LSP.completion_item_kind

vim.cmd.packadd('nvim-web-devicons')

---@type {[string]: string} source id to icon mapping
local source_id_to_icon = {
  lsp = '',
  snippets = '',
  path = '󰋊',
  buffer = '',
  dap = '',
  git = '',
  luasnip_choice = '',
}

---@type blink.cmp.Config
require('blink.cmp').setup({
  -- TODO: disabling
  completion = {
    trigger = {
      show_on_backspace = true,
    },
    ghost_text = {
      enabled = true,
      show_without_selection = true,
    },
    list = {
      selection = {
        preselect = false,
      },
    },
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', 'causes_additional_changes_indicator', gap = 1 },
          { 'source_icon' },
        },
        snippet_indicator = '', -- already communicated via kind
        treesitter = { 'lsp' },
        components = {
          kind_icon = {
            text = function(context)
              local is_path = context.source_name == 'Path'

              if is_path then
                return require('nvim-web-devicons').get_icon(context.label) or context.kind_icon
              else
                return vim.tbl_get(icons, context.kind, 'icon') or context.kind_icon
              end
            end,
            highlight = function(context)
              local is_path = context.source_name == 'Path'

              if is_path then
                local _, highlight = require('nvim-web-devicons').get_icon(context.label)
                return highlight or context.kind_hl
              else
                return vim.tbl_get(icons, context.kind, 'highlight') or context.kind_hl
              end
            end,
          },
          causes_additional_changes_indicator = {
            text = function(context)
              local has_additional_text_edits = #(context.item.additionalTextEdits or {}) > 0
              local has_command = context.item.command ~= nil
              return (has_additional_text_edits or has_command) and '󰺫' or ' '
            end,
          },
          source_icon = {
            text = function(context)
              return source_id_to_icon[context.source_id]
            end,
            highlight = 'LightGrey',
          },
        },
      },
    },
  },
  snippets = { preset = 'luasnip' },
  signature = { enabled = true },
  sources = {
    default = vim.list_extend(
      { 'luasnip_choice', 'dap', 'git' },
      require('blink.cmp.config.sources').default.default
    ),
    providers = {
      dap = {
        name = 'DAP',
        module = 'blink-cmp-dap',
      },
      git = {
        name = 'Git',
        module = 'blink-cmp-git',
        enabled = function()
          return vim.tbl_contains({ 'gitcommit', 'octo' }, vim.bo.filetype)
        end,
      },
      luasnip_choice = {
        name = 'LuaSnip Choice Nodes',
        module = 'blink-cmp-luasnip-choice',
        opts = {},
      },
    },
  },
  keymap = {
    preset = 'none',
  },
})
