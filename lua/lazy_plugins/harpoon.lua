return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    local harpoon_ui = require 'harpoon.ui'

    harpoon:setup()

    UTIL.register_keys {
      ['<leader>'] = {
        a = { function() harpoon:list():append() end, 'Add to Harpoon' },
        l = { function() harpoon_ui:toggle_quick_menu(harpoon:list()) end, 'Toggle Harpoon menu' },
      },
      ['<c-s-p>'] = { function() harpoon:list():prev() end, 'Harpoon previous' },
      ['<c-s-n>'] = { function() harpoon:list():next() end, 'Harpoon next' },
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
