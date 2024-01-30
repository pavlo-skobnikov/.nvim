return {
   'stevearc/oil.nvim', -- Vim buffer-like file explorer
   dependencies = { 'nvim-tree/nvim-web-devicons' },
   lazy = false,
   priority = 0,
   opts = { view_options = { show_hidden = true } },
   config = function()
      require('oil.init').setup()

      PG.reg_wk({ ['-'] = { '<cmd>Oil<cr>', 'Open parent directory' } })
   end,
}
