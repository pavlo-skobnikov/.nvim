return {
  'mbbill/undotree', -- A detailed undo history for files
  dependencies = { 'folke/which-key.nvim' },
  event = 'VeryLazy',
  config = function() U.register_keys { ['<leader>u'] = { ':UndotreeToggle<cr>', 'Undotree' } } end,
}
