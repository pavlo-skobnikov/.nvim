return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = function()
    local flash = require 'flash'

    return {
      { '<LEADER>jj', mode = { 'n', 'x', 'o' }, flash.jump, desc = 'Flash' },
      { '<LEADER>jt', mode = { 'n', 'x', 'o' }, flash.treesitter, desc = 'Flash Treesitter' },
      { '<LEADER>jr', mode = 'o', flash.remote, desc = 'Remote Flash' },
      { '<LEADER>jr', mode = { 'o', 'x' }, flash.treesitter_search, desc = 'Treesitter Search' },
    }
  end,
}
