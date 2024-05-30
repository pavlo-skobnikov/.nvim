require('oil').setup {
  -- Show files and directories that start with ".".
  view_options = { show_hidden = true },
  -- Remap split mappings. Also done to not interfere with vim-tmux-navigator.
  keymaps = {
    ['<C-h>'] = false,
    ['<C-x>'] = 'actions.select_split',
    ['<C-s>'] = false,
    ['<C-v>'] = 'actions.select_vsplit',
    ['<C-l>'] = false,
    ['<C-r>'] = 'actions.refresh',
  },
}

Set('n', '-', '<cmd>Oil<cr>', { desc = 'File explorer' })
