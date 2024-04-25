return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    vim.keymap.set('n', '<leader>a', function() harpoon:list():append() end, { desc = 'Add to Harpoon' })
    vim.keymap.set('n', '<leader>H', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon' })

    vim.keymap.set('n', '[h', function() harpoon:list():prev() end, { desc = 'Previous harpoon mark' })
    vim.keymap.set('n', ']h', function() harpoon:list():next() end, { desc = 'Next harpoon mark' })

    for i = 1, 9 do
      vim.keymap.set('n', 'g' .. i, function() harpoon:list():select(i) end, { desc = 'Go to Harpoon mark ' .. i })
    end
  end,
}
