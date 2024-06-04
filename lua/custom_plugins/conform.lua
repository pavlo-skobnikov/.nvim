-- Let's keep the code nice and tidy 🧹
return {
  'stevearc/conform.nvim',
  -- Ensure that formatters are installed.
  dependencies = 'WhoIsSethDaniel/mason-tool-installer.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      kotlin = { 'ktlint' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },
      ['_'] = { 'trim_whitespace' },
    },
    -- Arguments that are passed to conform.format()
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    -- Set the default formatexpr to use Conform.
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
