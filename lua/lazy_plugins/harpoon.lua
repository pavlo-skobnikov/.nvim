return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    U.register_keys {
      ['<leader>'] = {
        a = { function() harpoon:list():append() end, 'Add to Harpoon' },
        H = {
          function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
          'Harpoon',
        },
      },
      ['[h'] = { function() harpoon:list():prev() end, 'Previous harpoon mark' },
      [']h'] = { function() harpoon:list():next() end, 'Next harpoon mark' },
    }

    for i = 1, 9 do
      U.register_keys {
        ['g' .. i] = {
          function() harpoon:list():select(i) end,
          'Go to Harpoon mark ' .. i,
        },
      }
    end
  end,
}
