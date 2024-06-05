-- Pin files and switch between them quickly 🗃️
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function()
    local harpoon = require 'harpoon'

    local mappings = {
      { '<LEADER>ha', function() harpoon:list():add() end, desc = 'Add file' },
      {
        '<LEADER>hl',
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,

        desc = 'List files',
      },
      { '[h', function() harpoon:list():prev() end, desc = 'Previous Harpoon mark' },
      { ']h', function() harpoon:list():next() end, desc = 'Next Harpoon mark' },
    }

    for i = 1, 5 do
      table.insert(mappings, { 'g' .. i, function() harpoon:list():select(i) end, desc = 'Go to Harpoon mark ' .. i })
    end

    return mappings
  end,
}
