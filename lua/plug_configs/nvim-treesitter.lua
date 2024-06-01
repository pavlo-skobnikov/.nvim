---@diagnostic disable: missing-fields
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

  -- Configure additional textobjects
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
    swap = { enable = false },
  },
}