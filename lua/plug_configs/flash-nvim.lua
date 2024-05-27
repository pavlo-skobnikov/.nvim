local flash = require 'flash'

---@type Flash.Config
local opts = {}

flash.setup(opts)

Set({ 'n', 'x', 'o' }, '<SPACE>f', flash.jump, { desc = 'Flash' })
Set({ 'n', 'x', 'o' }, '<SPACE>t', flash.treesitter, { desc = 'Flash Treesitter' })
Set('o', '<SPACE>r', flash.remote, { desc = 'Remote Flash' })
Set({ 'o', 'x' }, '<SPACE>s', flash.treesitter_search, { desc = 'Treesitter Search' })
