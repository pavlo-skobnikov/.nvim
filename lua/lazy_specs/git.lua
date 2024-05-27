-- Git 'er done 💪
return {
  {
    'tpope/vim-fugitive', -- An outstanding git wrapper 🌯
    event = 'VeryLazy',
    config = function() require 'plug_configs.vim-fugitive' end,
  },
  {
    'echasnovski/mini.diff', -- Git gutter and minimalistic diff view 👓
    version = '*',
    event = 'BufEnter',
    config = function() require 'plug_configs.mini-diff' end,
  },
}
