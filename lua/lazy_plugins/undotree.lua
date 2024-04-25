return {
  'mbbill/undotree', -- A detailed undo history for files
  event = 'VeryLazy',
  config = function() vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = 'Undotree' }) end,
}
