return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    priority = 999,
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'File Explorer' },
    },
    opts = {
      -- Show files and directories that start with "."
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
    },
    config = function(_, opts) require('oil').setup(opts) end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
      local harpoon = require 'harpoon'

      local mappings = {
        { '<leader>a', function() harpoon:list():append() end, desc = 'Add to Harpoon' },
        { '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'Harpoon' },
        { '[h', function() harpoon:list():prev() end, desc = 'Previous harpoon mark' },
        { ']h', function() harpoon:list():next() end, desc = 'Next harpoon mark' },
      }

      for i = 1, 9 do
        table.insert(mappings, { 'g' .. i, function() harpoon:list():select(i) end, desc = 'Go to Harpoon mark ' .. i })
      end

      return mappings
    end,
    config = function() require('harpoon'):setup() end,
  },
}
