-- The limbo of plugins that coudln't find a home in other lazy plugin specification files 😔
return {
  {
    'Tummetott/unimpaired.nvim', -- Useful & comfy mappings for basic Vim commands 🐚
    event = 'BufEnter',
    config = function() require 'plug_configs.unimpaired-nvim' end,
  },
  {
    'christoomey/vim-tmux-navigator', -- Navigate seamlessly between Vim and Tmux panes 🪟
    keys = { '<C-h>', '<C-j>', '<C-k>', '<C-l>' },
    config = function() require 'plug_configs.vim-tmux-navigator' end,
  },
  {
    'mbbill/undotree', -- Visualize and navigate through local file modification history 📑
    keys = '<leader>u',
    config = function() require 'plug_configs.undotree' end,
  },
  { 'tpope/vim-repeat' }, -- A helper plugin for other plugins to add dot-repeat functionality 🔧
  {
    'folke/which-key.nvim', -- Mapping keys like it's nothing 🎆
    event = 'VeryLazy',
    config = function() require 'plug_configs.which-key' end,
  },
}
