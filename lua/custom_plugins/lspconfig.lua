-- Bridges mason.nvim with nvim-lspconfig 🌉
return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    -- LSP configuration galore.
    'neovim/nvim-lspconfig',
    -- nvim-cmp source for nvim-lsp.
    'hrsh7th/cmp-nvim-lsp',
    -- Ensures that language servers are installed.
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup()

    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )

    mason_lspconfig.setup_handlers {
      function(server_name) -- Default handler for setting up LSP servers.
        require('lspconfig')[server_name].setup { capabilities = capabilities }
      end,
      ['bashls'] = function()
        require('lspconfig').bashls.setup {
          filetypes = { 'sh', 'bash', 'zsh' },
          capabilities = capabilities,
        }
      end,
      ['jdtls'] = function() end, -- nvim-java handles the setup on its own.
    }
  end,
}
