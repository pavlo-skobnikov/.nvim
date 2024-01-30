return {
   'mbbill/undotree', -- A detailed undo history for files
   dependencies = { 'folke/which-key.nvim' },
   event = 'VeryLazy',
   config = function() PG.reg_wk({ ['<leader>u'] = { ':UndotreeToggle<cr>', 'Toggle Undotree' } }) end,
}
