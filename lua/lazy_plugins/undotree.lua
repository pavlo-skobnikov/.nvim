return {
  'mbbill/undotree', -- A detailed undo history for files
  dependencies = { 'folke/which-key.nvim' },
  event = 'VeryLazy',
  config = function() UTIL.register_keys { ['<leader>u'] = { ':UndotreeToggle<cr>', 'Undotree' } } end,
}
