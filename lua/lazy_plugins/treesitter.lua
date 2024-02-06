return {
  {
    'nvim-treesitter/nvim-treesitter', -- Syntax highlighting
    dependencies = { 'folke/which-key.nvim' },
    event = 'VeryLazy',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'c', -- Required for Treesitter to function parsers
        'lua',
        'vim',
        'vimdoc',
        'query',
        'diff', -- Additional parsers
        'gitattributes',
        'gitcommit',
        'gitignore',
        'http',
        'comment',
        'markdown',
        'markdown_inline',
        'json',
        'dockerfile',
        'yaml',
        'terraform',
        'hcl',
        'sql',
        'java',
      },

      sync_install = false, -- Install parsers synchronously
      auto_install = true, -- Auto-install missing parsers when entering buffer
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gs',
          node_incremental = ';',
          node_decremental = ',',
          scope_incremental = false,
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      vim.cmd [[ " Treesitter folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable " Disable folding at startup.
      ]]
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional Vim textobjects
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['ie'] = { query = '@parameter.inner', desc = 'inner argument element' },
            ['ae'] = { query = '@parameter.outer', desc = 'around argument element' },
            ['if'] = { query = '@function.inner', desc = 'inner function' },
            ['af'] = { query = '@function.outer', desc = 'around function' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['>e'] = { query = '@parameter.inner', desc = 'Swap argument forwards' },
            ['>f'] = { query = '@function.outer', desc = 'Swap function forwards' },
          },
          swap_previous = {
            ['<e'] = { query = '@parameter.inner', desc = 'Swap argument backwards' },
            ['<f'] = { query = '@function.outer', desc = 'Swap function backwards' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']a'] = { query = '@parameter.inner', desc = 'Next argument' },
            [']f'] = { query = '@function.outer', desc = 'Next function' },
          },
          goto_previous_start = {
            ['[a'] = { query = '@parameter.inner', desc = 'Previous argument' },
            ['[f'] = { query = '@function.outer', desc = 'Previous function' },
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      UTIL.register_keys({ ['['] = 'backwards', [']'] = 'forwards' }, { mode = { 'o', 'x' } })

      local repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      UTIL.register_keys({
        [';'] = { repeat_move.repeat_last_move_next, 'Repeat last move forwards' },
        [','] = { repeat_move.repeat_last_move_previous, 'Repeat last move backwards' },
        ['f'] = { repeat_move.builtin_f, 'Search char forwards' },
        ['F'] = { repeat_move.builtin_F, 'Search char backwards' },
        ['t'] = { repeat_move.builtin_t, 'Search until char forwards' },
        ['T'] = { repeat_move.builtin_T, 'Search until char backwards' },
      }, { mode = { 'n', 'x', 'o' } })
    end,
  },
  {
    'nvim-treesitter/playground', -- Treesitter query playground
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    config = function()
      UTIL.register_keys({
        p = {
          name = 'ts-playground',
          p = { ':TSPlaygroundToggle<cr>', 'Toggle playground' },
          h = { ':TSHighlightCapturesUnderCursor<cr>', 'Highlight captures under cursor' },
          n = { ':TSNodeUnderCursor<cr>', 'Highlight node under cursor' },
        },
      }, { prefix = '<leader>' })
    end,
  },
}
