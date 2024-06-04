-- Navigate seamlessly between Vim and Tmux panes 🪟
return {
  'christoomey/vim-tmux-navigator',
  keys = {
    { '<C-h>', '<CMD>TmuxNavigateLeft<CR>', desc = 'Navigate window/pane left' },
    { '<C-j>', '<CMD>TmuxNavigateDown<CR>', desc = 'Navigate window/pane down' },
    { '<C-k>', '<CMD>TmuxNavigateUp<CR>', desc = 'Navigate window/pane up' },
    { '<C-l>', '<CMD>TmuxNavigateRight<CR>', desc = 'Navigate window/pane right' },
  },
  config = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_save_on_switch = 2
  end,
}
