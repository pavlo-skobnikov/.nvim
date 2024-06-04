-- Vim-buffer-like file explorer 🛢️
return {
  'stevearc/oil.nvim',
  lazy = false,
  priority = 999,
  keys = { { '-', '<cmd>Oil<cr>', desc = 'File explorer' } },
  opts = {
    -- Show files and directories that start with ".".
    view_options = { show_hidden = true },
    -- Remap split mappings. Also done to not interfere with vim-tmux-navigator.
    keymaps = {
      ['<C-h>'] = false,
      ['<C-s>'] = 'actions.select_split',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-l>'] = false,
      ['<C-r>'] = 'actions.refresh',
    },
  },
}
