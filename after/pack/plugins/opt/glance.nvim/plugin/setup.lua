local glance = require('glance')

glance.register_method({
  name = 'vue_file_references',
  method = 'volar/client/findFileReference',
  label = 'Component Usages',
})

glance.register_method({
  name = 'rust-analyzer_related-tests',
  method = 'rust-analyzer/relatedTests',
  label = 'Related Tests',
})

glance.setup({
  folds = {
    fold_closed = vim.opt.fillchars:get().foldclose,
    fold_open = vim.opt.fillchars:get().foldopen,
  },
  border = {
    enable = true,
    top_char = '▔',
    bottom_char = '▁',
  },
  list = {
    position = 'left',
  },
  hooks = {
    before_open = function(results, open, _, method)
      if method == 'rust-analyzer_related-tests' then
        results = vim
          .iter(results)
          :map(function(entry)
            return entry.runnable.location
          end)
          :totable()
      end

      open(results)
    end,
  },
  mappings = {
    list = {
      t = false, -- Avoid conflict with custom buffer local key mapping.
    },
  },
})
