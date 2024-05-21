-- View it, snip it, yank it, code it. Now with extra comfort and speed! 🚘
return {
  {
    'windwp/nvim-autopairs', -- Even quotes and brackets shouldn't be alone, don't you think?
    event = 'InsertEnter',
    config = true,
  },
  {
    'tpope/vim-surround', -- Add, change, and delete paired surrounding characters 🎭
    keys = { 'ys', 'ds', 'cs' },
  },
  {
    'julienvincent/nvim-paredit', -- (paredit nvim) 🤓
    event = 'InsertEnter *.clj',
    config = function() require 'plug_configs.nvim-paredit' end,
  },
  {
    'RRethy/vim-illuminate', -- Auto-highlighting of symbols under the cursor 💡
    event = 'BufEnter',
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
}
