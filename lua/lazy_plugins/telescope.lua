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
    event = 'VeryLazy',
    config = function()
      require('telescope').setup {
        defaults = {
          dynamic_preview_title = true,
          path_display = { 'tail' },
          layout_strategy = 'vertical',
          layout_config = { vertical = { mirror = false } },
          pickers = { lsp_incoming_calls = { path_display = 'tail' } },
        },
      }

      local telescope_builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>t', '<cmd>Telescope<cr>', { desc = 'Telescope' })
      vim.keymap.set(
        'n',
        '<leader>ff',
        function() telescope_builtin.find_files { find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } } end,
        { desc = 'All files' }
      )
      vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Grep' })
      vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Search documentation' })
      vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, { desc = 'Resume previous search' })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    config = function() require('telescope').load_extension 'ui-select' end,
  },
  {
    'nvim-telescope/telescope-fzy-native.nvim', -- Blazingly-fast C port of FZF for Telescope
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    build = 'make',
    config = function() require('telescope').load_extension 'fzy_native' end,
  },
}
