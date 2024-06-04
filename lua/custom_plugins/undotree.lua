-- Visualize and navigate through local file modification history 📑
return {
  'mbbill/undotree',
  keys = { { Leader .. 'u', '<CMD>UndotreeToggle<CR>', desc = 'Undo history' } },
}
