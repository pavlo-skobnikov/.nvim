return {
  'stevearc/oil.nvim',
  priority = 999,
  config = function()
    -- Show files and directories that start with "."
    require('oil').setup { view_options = { show_hidden = true } }

    U.register_keys { ['-'] = { '<cmd>Oil<cr>', 'File Explorer' } }
  end,
}
