-- Moving around at the speed of sound (or more like the speed of my thought 💭).
return {
  {
    'stevearc/oil.nvim', -- Vim-buffer-like file explorer 🛢️
    lazy = false,
    priority = 999,
    config = function() require 'plug_configs.oil-nvim' end,
  },
  {
    'ThePrimeagen/harpoon', -- Pin files and switch between them quickly 🗃️
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { '<leader>a', '<leader>h' },
    config = function() require 'plug_configs.harpoon' end,
  },
  {
    'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder 🔭
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
      {
        'nvim-telescope/telescope-fzf-native.nvim', -- Blazingly-fast C port of FZF for Telescope.
        build = 'make',
      },
    },
    keys = { '<leader>t', '<leader>f', '<leader>s', '<leader>/', '<leader>r', '<leader>q' },
    config = function() require 'plug_configs.telescope' end,
  },
}
