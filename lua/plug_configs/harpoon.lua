local harpoon = require 'harpoon'

harpoon:setup()

SetG('n', 'ha', function() harpoon:list():add() end, { desc = 'Add file' })
SetG('n', 'hl', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'List files' })
Set('n', '[h', function() harpoon:list():prev() end, { desc = 'Previous mark' })
Set('n', ']h', function() harpoon:list():next() end, { desc = 'Next mark' })

--[[
Keep the amount of quickly accessible marks to a minimum.

1 to 5 range is enough for most use cases and is kept consistent in access i.e. the left hand
handles direct access to the marks.
--]]
for i = 1, 5 do
  Set('n', 'g' .. i, function() harpoon:list():select(i) end, { desc = 'Go to Harpoon mark ' .. i })
end
