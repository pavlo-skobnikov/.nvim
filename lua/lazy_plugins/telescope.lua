return {
  {
    'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder over lists
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    opts = {
      defaults = {
        dynamic_preview_title = true,
        path_display = { 'tail' },
        layout_strategy = 'vertical',
        layout_config = { vertical = { mirror = false } },
        pickers = { lsp_incoming_calls = { path_display = 'tail' } },
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      local telescope_builtin = require 'telescope.builtin'

      UTIL.register_keys {
        ['<leader>f'] = {
          name = 'find',
          f = {
            function() telescope_builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } } end,
            'All files',
          },
          g = { telescope_builtin.live_grep, 'grep' },
          s = { telescope_builtin.spell_suggest, 'View spelling suggestion & apply' },
          h = { telescope_builtin.help_tags, 'Search documentation' },
          r = { telescope_builtin.resume, 'Resume previous search' },
        },
      }
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    config = function() require('telescope').load_extension 'ui-select' end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim', -- Blazingly-fast C port of FZF for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    build = 'make',
    config = function() require('telescope').load_extension 'fzf' end,
  },
}
