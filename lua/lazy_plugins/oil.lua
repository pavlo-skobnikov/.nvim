return {
  'stevearc/oil.nvim',
  priority = 999,
  config = function()
    require('oil').setup {
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
      use_default_keymaps = false, -- Disable default keymaps
      view_options = { show_hidden = true }, -- Show files and directories that start with "."
    }

    UTIL.register_keys { ['-'] = { '<cmd>Oil<cr>', 'Open file explorer' } }
  end,
}
