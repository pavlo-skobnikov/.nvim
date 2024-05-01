return {
  {
    'nvim-treesitter/nvim-treesitter', -- Syntax highlighting
    event = 'BufEnter',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c', -- Parsers required for Treesitter to function
          'lua',
          'vim',
          'vimdoc',
          'query',
          'diff', -- Additional parsers
          'gitattributes',
          'gitcommit',
          'gitignore',
          'comment',
          'markdown',
          'markdown_inline',
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
      }

      vim.cmd [[ " Treesitter folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable " Disable folding at startup.
      ]]
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional Vim textobjects
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'BufEnter',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['ia'] = { query = '@parameter.inner', desc = 'inner argument' },
              ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
              ['if'] = { query = '@function.inner', desc = 'inner function' },
              ['af'] = { query = '@function.outer', desc = 'around function' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              [']S'] = { query = '@parameter.inner', desc = 'Swap argument forwards' },
            },
            swap_previous = {
              ['[S'] = { query = '@parameter.inner', desc = 'Swap argument backwards' },
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
      }

      local repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      local modes = { 'n', 'x', 'o' }

      vim.keymap.set(modes, ';', repeat_move.repeat_last_move_next, { desc = 'Repeat last move forwards' })
      vim.keymap.set(modes, ',', repeat_move.repeat_last_move_previous, { desc = 'Repeat last move backwards' })
      vim.keymap.set(modes, 'f', repeat_move.builtin_f, { desc = 'Search char forwards' })
      vim.keymap.set(modes, 'F', repeat_move.builtin_F, { desc = 'Search char backwards' })
      vim.keymap.set(modes, 't', repeat_move.builtin_t, { desc = 'Search until char forwards' })
      vim.keymap.set(modes, 'T', repeat_move.builtin_T, { desc = 'Search until char backwards' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'BufEnter',
    keys = {
      {
        'gC',
        function() require('treesitter-context').go_to_context(vim.v.count1) end,
        desc = 'Go to surrounding context',
      },
    },
  },
  {
    'nvim-treesitter/playground', -- Treesitter query playground
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = 'TSPlaygroundToggle ',
  },
}
