local harpoon = require 'harpoon'

harpoon:setup()

vim.keymap.set('n', '<leader>a', function() harpoon:list():append() end, { desc = 'Add file to Harpoon' })
vim.keymap.set('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon list' })
vim.keymap.set('n', '[h', function() harpoon:list():prev() end, { desc = 'Previous Harpoon mark' })
vim.keymap.set('n', ']h', function() harpoon:list():next() end, { desc = 'Next Harpoon mark' })

for i = 1, 9 do
  vim.keymap.set('n', 'g' .. i, function() harpoon:list():select(i) end, { desc = 'Go to Harpoon mark ' .. i })
end
