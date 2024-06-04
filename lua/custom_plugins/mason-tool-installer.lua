-- Programmatically define the tools to be installed by mason.nvim.
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  -- Easy language server and other tools management.
  dependencies = { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  event = 'VeryLazy',
  opts = {
    ensure_installed = {
      -- Lua.
      'lua-language-server',
      'stylua',
      -- Kotlin.
      'kotlin-language-server',
      'kotlin-debug-adapter',
      'ktlint',
      -- HTML.
      'html-lsp',
      'emmet-language-server',
      -- CSS.
      'css-lsp',
      'tailwindcss-language-server',
      'stylelint',
      -- JavaScript.
      'typescript-language-server',
      'eslint-lsp',
      -- Bash
      'bash-language-server',
      'shfmt',
      -- Other tools.
      'prettier',
    },

    -- Disable all the integrations.
    integrations = {
      ['mason-lspconfig'] = false,
      ['mason-null-ls'] = false,
      ['mason-nvim-dap'] = false,
    },
  },
  config = function(_, opts)
    require('mason').setup()
    require('mason-tool-installer').setup(opts)
  end,
}
