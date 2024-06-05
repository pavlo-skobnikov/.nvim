-- An outstanding git wrapper 🌯
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  keys = {
    { '<LEADER>gg', '<CMD>Git<CR>', desc = 'Git' },
    { '<LEADER>gb', '<CMD>Git blame<CR>', desc = 'Git blame' },
  },
}
