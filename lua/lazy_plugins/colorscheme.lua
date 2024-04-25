return {
  'catppuccin/nvim', -- A purrfect colorscheme
  lazy = false,
  priority = 1000,
  main = 'catppuccin',
  config = function()
    require('catppuccin').setup { flavour = 'frappe' }

    vim.cmd [[ colorscheme catppuccin ]]
  end,
}
