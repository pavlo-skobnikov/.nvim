return {
   'catppuccin/nvim', -- A purrfect colorscheme
   lazy = false,
   priority = 0,
   main = 'catppuccin',
   opts = { flavour = 'frappe' },
   config = function(_, opts)
      -- Set up the plugin
      require('catppuccin').setup(opts)

      -- Set the colorscheme
      vim.cmd([[ colorscheme catppuccin ]])
   end,
}
