-- Let's make it purdy! 💅
return { -- A purrfect colorscheme for Neovim 🐱
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  main = 'catppuccin',
  config = function()
    require('catppuccin').setup { flavour = 'frappe' }

    vim.cmd [[ colorscheme catppuccin ]]
  end,
}
