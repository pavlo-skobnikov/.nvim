require('mason').setup()

local mason_config = require 'mason-lspconfig.init'
local lsp_config = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup Mason LSP config
mason_config.setup {
  ensure_installed = {
    'clangd', -- C
    'lua_ls', -- Lua
    'pylsp', -- Python
    'gopls', -- Go
    'jdtls', -- Java
    'kotlin_language_server', -- Kotlin
    -- Scala & Metals are not managed by Mason :)
    'tsserver', -- TypeScript
    'bashls', -- Bash
    'marksman', -- Markdown
    'dockerls', -- Dockerfile
    'docker_compose_language_service', -- Docker Compose
    'sqlls', -- SQL
    'yamlls', -- YAML
    'jsonls', -- JSON
  },
  handlers = {
    -- Default handler for all LSP servers
    function(serverName)
      if vim.tbl_contains({ 'jdtls' }, serverName) then return end

      lsp_config[serverName].setup { capabilities = capabilities }
    end,
    -- Java is handled by nvim-jdtls
    ['jdtls'] = function() end,
  },
}
