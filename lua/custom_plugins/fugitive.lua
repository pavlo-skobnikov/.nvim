-- An outstanding git wrapper 🌯
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  keys = {
    { Leader .. 'gg', '<CMD>Git<CR>', desc = 'Git' },
    { Leader .. 'gb', '<CMD>Git blame<CR>', desc = 'Git blame' },
  },
}
