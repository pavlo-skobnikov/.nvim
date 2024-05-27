vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_save_on_switch = 2

vim.keymap.set('n', '<C-h>', '<CMD>TmuxNavigateLeft<CR>', { desc = 'Navigate window/pane left' })
vim.keymap.set('n', '<C-j>', '<CMD>TmuxNavigateDown<CR>', { desc = 'Navigate window/pane down' })
vim.keymap.set('n', '<C-k>', '<CMD>TmuxNavigateUp<CR>', { desc = 'Navigate window/pane up' })
vim.keymap.set('n', '<C-l>', '<CMD>TmuxNavigateRight<CR>', { desc = 'Navigate window/pane right' })
