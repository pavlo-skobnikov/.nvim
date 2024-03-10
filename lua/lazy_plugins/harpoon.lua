return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    UTIL.register_keys {
      ['<leader>'] = {
        a = { function() harpoon:list():append() end, 'Add to Harpoon' },
        l = {
          function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
          'Toggle Harpoon menu',
        },
      },
      ['[h'] = { function() harpoon:list():prev() end, 'Previous ' },
      [']h'] = { function() harpoon:list():next() end, 'Harpoon next' },
    }

    for i = 1, 9 do
      UTIL.register_keys {
        ['g' .. i] = {
          function() harpoon:list():select(i) end,
          'Go to Harpoon mark ' .. i,
        },
      }
    end
  end,
}
