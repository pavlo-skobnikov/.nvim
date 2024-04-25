return {
  {
    'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Package manager for Neovim
      'neovim/nvim-lspconfig', -- Configs for the Nvim LSP client (:help lsp)
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'VeryLazy',
    config = function()
      -- Setup Mason for package management
      require('mason').setup()

      local mason_config = require 'mason-lspconfig.init'
      local lsp_config = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup Mason LSP config
      mason_config.setup {
        ensure_installed = {
          'clangd', -- C
          'zls', -- Zig
          'rust_analyzer', -- Rust
          'lua_ls', -- Lua
          'pylsp', -- Python
          'gopls', -- Go
          'jdtls', -- Java
          'kotlin_language_server', -- Kotlin
          'clojure_lsp', -- Clojure
          -- Scala & Metals are not managed by Mason :)
          -- Gleam isn't managed by Mason either!
          'tsserver', -- TypeScript
          'bashls', -- Bash
          'marksman', -- Markdown
          'dockerls', -- Dockerfile
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
    end,
  },
  {
    'nvim-java/nvim-java', -- Java support
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
    },
    config = function()
      local java = require 'java'

      java.setup()
      require('lspconfig').jdtls.setup {}

      vim.keymap.set('n', '<leader>mr', java.runner.built_in.run_app, { desc = 'Run' })
      vim.keymap.set('n', '<leader>mR', function ()
        local input = vim.fn.input 'App arguments: '

        -- Convert the input string into a table of arguments
        local arguments = {}
        for arg in string.gmatch(input, '%S+') do
          table.insert(arguments, arg)
        end

        java.runner.built_in.run_app(arguments)
      end, { desc = 'Run with arguments' })
      vim.keymap.set('n', '<leader>ms', java.runner.built_in.stop_app, { desc = 'Stop' })
      vim.keymap.set('n', '<leader>ml', java.runner.built_in.toggle_logs, { desc = 'Toggle logs' })
      vim.keymap.set('n', '<leader>md', java.dap.config_dap, { desc = 'Configure DAP' })
      vim.keymap.set('n', '<leader>mc', java.test.run_current_class, { desc = 'Run class' })
      vim.keymap.set('n', '<leader>mC', java.test.debug_current_class, { desc = 'Debug class' })
      vim.keymap.set('n', '<leader>mm', java.test.run_current_method, { desc = 'Run method' })
      vim.keymap.set('n', '<leader>mM', java.test.debug_current_method, { desc = 'Debug method' })
      vim.keymap.set('n', '<leader>mr', java.test.view_last_report, { desc = 'View last report' })
      vim.keymap.set('n', '<leader>mu', java.profile.ui, { desc = 'Profile UI' })
    end,
  },
  {
    'scalameta/nvim-metals', -- Scala support
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt' },
    config = function()
      local metals = require 'metals'
      local metals_cfg = metals.bare_config()
      local dap = require 'dap'

      metals_cfg.on_attach = function()
        -- Metals-specific configurations
        metals_cfg.init_options.statusBarProvider = 'on'
        metals_cfg.settings = {
          showImplicitArguments = true,
          excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
        }

        -- Setup capabilites for `cmp` snippets
        metals_cfg.capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Add a Scala DAP client
        -- > ...metals.args = { "firstArg", "secondArg",.. }, -- An example of additional arguments
        ---@diagnostic disable-next-line: undefined-field
        dap.configurations.scala = {
          { type = 'scala', request = 'launch', name = 'RunOrTest', metals = { runType = 'runOrTestFile' } },
          { type = 'scala', request = 'launch', name = 'Test Target', metals = { runType = 'testTarget' } },
        }

        metals.setup_dap()

        -- Set Metals-specific keymaps
        vim.keymap.set('n', '<leader>mw', metals.workspace_open, { desc = 'Open workspace' })
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvimMetals', { clear = true }),
        -- pattern = { 'scala', 'sbt', 'java' }, -- If basic Java support is required
        pattern = { 'scala', 'sbt' },
        callback = function() metals.initialize_or_attach(metals_cfg) end,
        desc = 'Set Metals up',
      })
    end,
  },
}
