-- Git 'er done 💪
return {
  {
    'tpope/vim-fugitive', -- An outstanding git wrapper 🌯
    cmd = { 'G', 'Git' },
    keys = { '<leader>g', 'yog' },
    config = function() require 'plug_configs.vim-fugitive' end,
  },
  {
    'echasnovski/mini.diff', -- Git gutter and minimalistic diff view 👓
    version = '*',
    event = 'BufEnter',
    keys = { 'yoD' },
    config = function() require 'plug_configs.mini-diff' end,
  },
}
