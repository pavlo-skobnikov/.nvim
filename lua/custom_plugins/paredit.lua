-- S-expression manipulation 🎛️
return {
  'julienvincent/nvim-paredit',
  ft = 'clojure',
  opts = {},
  config = function(_, opts) require('nvim-paredit').setup(opts) end,
}
