return {
  'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin
  dependencies = {
    { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Package manager for Neovim
    'neovim/nvim-lspconfig', -- Configs for the Nvim LSP client (:help lsp)
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'hrsh7th/cmp-nvim-lsp',
  },
  event = 'VeryLazy',
  opts = {
    ensure_installed = {
      'clangd', -- C
      'zls', -- Zig
      'rust_analyzer', -- Rust
      'lua_ls', -- Lua
      'pylsp', -- Python
      'gopls', -- Go
      'gleam', -- Gleam
      'jdtls', -- Java
      'kotlin_language_server', -- Kotlin
      'clojure_lsp', -- Clojure
      'tsserver', -- TypeScript
      'bashls', -- Bash
      'marksman', -- Markdown
      'dockerls', -- Dockerfile
      'sqlls', -- SQL
      'yamlls', -- YAML
      'jsonls', -- JSON
    },
  },
  config = function(_, opts)
    -- Setup Mason for package management
    require('mason').setup()

    local mason_config = require 'mason-lspconfig.init'
    local lsp_config = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Setup Mason LSP config
    mason_config.setup(opts)

    -- Setup separate LSP configs for various languages
    -- * Except for Java, which is handled by nvim-jdtls
    mason_config.setup_handlers {
      function(serverName)
        if vim.tbl_contains({ 'jdtls' }, serverName) then return end

        lsp_config[serverName].setup { capabilities = capabilities }
      end,
    }
  end,
}
