return {
  'catppuccin/nvim', -- A purrfect colorscheme
  lazy = false,
  priority = 0,
  main = 'catppuccin',
  opts = { flavour = 'frappe' },
  config = function(_, opts)
    require('catppuccin').setup(opts)

    vim.cmd [[ colorscheme catppuccin ]]
  end,
}
