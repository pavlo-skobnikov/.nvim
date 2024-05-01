return {
  {
    'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder over lists
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    keys = function()
      local telescope_builtin = require 'telescope.builtin'

      return {
        { '<leader>t', '<cmd>Telescope<cr>', desc = 'Telescope' },
        {
          '<leader>f',
          function() telescope_builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } } end,
          desc = 'All files',
        },
        { '<leader>/', telescope_builtin.live_grep, desc = 'Grep' },
        { '<leader>H', telescope_builtin.help_tags, desc = 'Search documentation' },
        { '<leader>r', telescope_builtin.resume, desc = 'Resume previous search' },
        { '<leader>q', telescope_builtin.quickfix, desc = 'Search quickfix' },
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
    },
    config = function(_, opts) require('telescope').setup(opts) end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    lazy = true,
    config = function() require('telescope').load_extension 'ui-select' end,
  },
  {
    'nvim-telescope/telescope-fzy-native.nvim', -- Blazingly-fast C port of FZF for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    lazy = true,
    build = 'make',
    config = function() require('telescope').load_extension 'fzy_native' end,
  },
}
