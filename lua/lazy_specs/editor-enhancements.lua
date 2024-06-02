-- View it, snip it, yank it, code it. Now with extra comfort and speed! 🚘
return {
  {
    'windwp/nvim-autopairs', -- Even quotes and brackets shouldn't be alone, don't you think?
    event = 'InsertEnter',
    config = true,
  },
  {
    'tpope/vim-surround', -- Add, change, and delete paired surrounding characters 🎭
    event = 'BufEnter',
  },
  {
    'RRethy/vim-illuminate', -- Auto-highlighting of symbols under the cursor 💡
    event = 'BufEnter',
  },
  {
    'folke/flash.nvim', -- Zap across the text ⚡︎
    event = 'VeryLazy',
    config = function() require 'plug_configs.flash-nvim' end,
  },
  {
    'Tummetott/unimpaired.nvim', -- Useful & comfy mappings for basic Vim commands 🐚
    event = 'BufEnter',
    config = function() require 'plug_configs.unimpaired-nvim' end,
  },
  {
    'nvim-treesitter/nvim-treesitter', -- Blazingly-fast syntax highlighting 🌅
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context', -- Always see the surrounding context even if it's too far up.
      'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects to play around with.
    },
    event = 'BufEnter',
    build = ':TSUpdate',
    config = function() require 'plug_configs.nvim-treesitter' end,
  },
  {
    'christoomey/vim-tmux-navigator', -- Navigate seamlessly between Vim and Tmux panes 🪟
    event = 'VeryLazy',
    config = function() require 'plug_configs.vim-tmux-navigator' end,
  },
  {
    'mbbill/undotree', -- Visualize and navigate through local file modification history 📑
    event = 'VeryLazy',
    config = function() require 'plug_configs.undotree' end,
  },
  {
    'tpope/vim-repeat', -- A helper plugin for other plugins to add dot-repeat functionality 🔧
    event = 'VeryLazy',
  },
  {
    'folke/which-key.nvim', -- Mapping keys like it's nothing 🎆
    event = 'VeryLazy',
    config = function() require 'plug_configs.which-key' end,
  },
}
