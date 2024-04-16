return {
  {
    'christoomey/vim-tmux-navigator', -- Seamless navitation between Vim and Tmux splits
    dependencies = { 'folke/which-key.nvim' },
    event = 'VeryLazy',
    config = function()
      U.register_keys({
        ['<C-h>'] = { '<CMD>TmuxNavigateLeft<CR>', 'Move a split left' },
        ['<C-j>'] = { '<CMD>TmuxNavigateDown<CR>', 'Move a split down' },
        ['<C-k>'] = { '<CMD>TmuxNavigateUp<CR>', 'Move a split up' },
        ['<C-l>'] = { '<CMD>TmuxNavigateRight<CR>', 'Move a split right' },
      }, { mode = { 'n', 'x', 'o' } })

      vim.cmd [[
          let g:tmux_navigator_no_mappings = 1
          let g:tmux_navigator_save_on_switch = 2
        ]]
    end,
  },
}
