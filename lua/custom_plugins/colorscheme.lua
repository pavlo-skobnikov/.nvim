-- A groovy colorscheme for Neovim 🐱
return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  main = 'catppuccin',
  opts = {},
  config = function(_, opts)
    require('gruvbox').setup(opts)

    vim.cmd [[ colorscheme gruvbox ]]
  end,
}
