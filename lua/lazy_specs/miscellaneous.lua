-- The limbo of plugins that coudln't find a home in other lazy plugin specification files 😔
return {
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
