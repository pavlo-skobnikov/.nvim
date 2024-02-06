return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-telescope/telescope.nvim' },
  opts = {},
  config = function(_, opts)
    local trouble = require 'trouble'

    trouble.setup(opts)

    UTIL.register_keys {
      g = {
        x = { trouble.toggle, 'Toggle Trouble' },
        r = { function() trouble.toggle 'lsp_references' end, 'Go to references' },
        w = { function() trouble.toggle 'document_diagnostics' end, 'Go to document warnings' },
        W = { function() trouble.toggle 'workspace_diagnostics' end, 'Go to workspace warnings' },
        q = { function() trouble.toggle 'quickfix' end, 'View quickfix list' },
        l = { function() trouble.toggle 'loclist' end, 'View location list' },
      },
      ['[x'] = { function() trouble.previous { skip_groups = true, jump = true } end, 'Previous diagnostic' },
      ['[X'] = { function() trouble.first { skip_groups = true, jump = true } end, 'Previous diagnostic' },
      [']x'] = { function() trouble.next { skip_groups = true, jump = true } end, 'Next diagnostic' },
      [']X'] = { function() trouble.last { skip_groups = true, jump = true } end, 'Next diagnostic' },
    }

    local trouble_telescope = require 'trouble.providers.telescope'
    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<c-t>'] = trouble_telescope.open_with_trouble },
          n = { ['<c-t>'] = trouble_telescope.open_with_trouble },
        },
      },
    }
  end,
}
