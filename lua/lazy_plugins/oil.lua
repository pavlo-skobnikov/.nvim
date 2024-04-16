return {
  'stevearc/oil.nvim',
  priority = 999,
  config = function()
    -- Show files and directories that start with "."
    require('oil').setup {
      view_options = { show_hidden = true },
      -- In order not to conflict with tmux-navigator
      use_default_keymaps = false, -- Disable default keymaps
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<cr>'] = 'actions.select',
        ['<c-v>'] = 'actions.select_vsplit',
        ['<c-s>'] = 'actions.select_split',
        ['<c-t>'] = 'actions.select_tab',
        ['<c-p>'] = 'actions.preview',
        ['<c-c>'] = 'actions.close',
        ['<c-r>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
    }

    U.register_keys { ['-'] = { '<cmd>Oil<cr>', 'File Explorer' } }
  end,
}
