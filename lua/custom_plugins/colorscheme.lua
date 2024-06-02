-- Let's make it purdy! 💅
return { -- A purrfect colorscheme for Neovim 🐱
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  main = 'catppuccin',
  opts = { flavour = 'frappe' },
  config = function(_, opts)
    require('catppuccin').setup(opts)

    vim.cmd [[ colorscheme catppuccin ]]
  end,
}
