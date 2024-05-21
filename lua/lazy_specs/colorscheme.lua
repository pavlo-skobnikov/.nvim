-- Let's make it purdy! 💅
return {
  'catppuccin/nvim', -- A purrfect colorscheme for Neovim 🐱
  lazy = false,
  priority = 1000,
  main = 'catppuccin',
  config = function() require 'plug_configs.catppuccin' end,
}
