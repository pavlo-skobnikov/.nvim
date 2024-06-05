-- Support for linting tools that are not LSP-based 🌤️
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<LEADER>L', function() require('lint').try_lint() end, desc = 'Lint the current buffer' },
  },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      kotlin = { 'ktlint' },
      css = { 'stylelint' },
      sass = { 'stylelint' },
      scss = { 'stylelint' },
      less = { 'stylelint' },
    }

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('LintCurrentBuffer', { clear = true }),
      callback = function() require('lint').try_lint() end,
      desc = 'Lint the current buffer',
    })
  end,
}
