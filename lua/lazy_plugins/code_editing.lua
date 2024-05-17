return {
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true }, -- Auto-pairing of brackets, quotes, etc.
  { 'tpope/vim-repeat' }, -- Extra dot-repeating functionality
  { 'tpope/vim-surround', keys = { 'ys', 'ds', 'cs' } }, -- Actions on surrounding characters (e.g. brackets & quotes)
}
