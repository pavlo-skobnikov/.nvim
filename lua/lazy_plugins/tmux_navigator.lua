return {
  {
    'christoomey/vim-tmux-navigator', -- Seamless navitation between Vim and Tmux splits
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<C-h>', '<CMD>TmuxNavigateLeft<CR>', { desc = 'Move a split left' })
      vim.keymap.set('n', '<C-j>', '<CMD>TmuxNavigateDown<CR>', { desc = 'Move a split down' })
      vim.keymap.set('n', '<C-k>', '<CMD>TmuxNavigateUp<CR>', { desc = 'Move a split up' })
      vim.keymap.set('n', '<C-l>', '<CMD>TmuxNavigateRight<CR>', { desc = 'Move a split right' })

      vim.cmd [[
          let g:tmux_navigator_no_mappings = 1
          let g:tmux_navigator_save_on_switch = 2
        ]]
    end,
  },
}
