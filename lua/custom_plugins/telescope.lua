-- An incredibly extendable fuzzy finder 🔭
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    -- UI picker extension for Telescope
    'nvim-telescope/telescope-ui-select.nvim',
    -- Blazingly-fast C port of FZF for Telescope.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  keys = function()
    local builtin = require 'telescope.builtin'

    return {
      -- Basic actions.
      { Leader .. 'fx', builtin.commands, desc = 'Search and execute commands' },
      { Leader .. '/', builtin.current_buffer_fuzzy_find, desc = 'Fuzzy search in buffer' },

      { Leader .. 'fa', '<cmd>Telescope<cr>', desc = 'Telescope actions' },
      { Leader .. 'fr', builtin.resume, desc = 'Resume search' },
      { Leader .. 'f<C-h>', builtin.help_tags, desc = 'Help tags' },

      { Leader .. 'ff', builtin.find_files, desc = 'Find files' },
      { Leader .. 'fh', builtin.oldfiles, desc = 'Opened files history' },

      { Leader .. 'fg', builtin.live_grep, desc = 'grep' },

      { Leader .. 'fq', builtin.quickfix, desc = 'Quickfix list' },
      { Leader .. 'fQ', builtin.quickfixhistory, desc = 'Quickfix list' },
      { Leader .. 'fR', builtin.registers, desc = 'Registers' },

      -- Git.
      { Leader .. 'gc', builtin.git_commits, desc = 'Commits' },
      { Leader .. 'gC', builtin.git_bcommits, desc = 'Buffer commits' },
      { Leader .. 'gB', builtin.git_branches, desc = 'Branches' },
      { Leader .. 'gs', builtin.git_status, desc = 'Status' },
      { Leader .. 'gS', builtin.git_stash, desc = 'Stash' },
    }
  end,
  opts = {
    defaults = {
      dynamic_preview_title = true,
      path_display = { 'tail' },
      layout_strategy = 'vertical',
      layout_config = { vertical = { mirror = false } },
      pickers = { lsp_incoming_calls = { path_display = 'tail' } },
    },
    extensions = {
      fzf = {},
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'

    telescope.setup(opts)

    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
  end,
}
