-- Color highlighter and picker for Neovim 🎨
return {
  'uga-rosa/ccc.nvim',
  event = 'VeryLazy',
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  config = function(_, opts)
    -- Required for the plugin to work.
    vim.opt.termguicolors = true

    require('ccc').setup(opts)
  end,
}
