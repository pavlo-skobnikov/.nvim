return {
  -- Language-specific support plugins.
  {
    'nvim-java/nvim-java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
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
    ft = { 'java' },
    keys = function()
      local java = require 'java'

      return {
        { 'mr', java.runner.built_in.run_app, ft = { 'java' }, desc = 'Run' },
        {
          'mR',
          function()
            local input = vim.fn.input 'App arguments: '

            -- Convert the input string into a table of arguments
            local arguments = {}
            for arg in string.gmatch(input, '%S+') do
              table.insert(arguments, arg)
            end

            java.runner.built_in.run_app(arguments)
          end,
          ft = { 'java' },
          desc = 'Run with arguments',
        },
        { 'ms', java.runner.built_in.stop_app, ft = { 'java' }, desc = 'Stop' },
        { 'ml', java.runner.built_in.toggle_logs, ft = { 'java' }, desc = 'Toggle logs' },
        { 'md', java.dap.config_dap, ft = { 'java' }, desc = 'Configure DAP' },
        { 'mc', java.test.run_current_class, ft = { 'java' }, desc = 'Run test class' },
        { 'mC', java.test.debug_current_class, ft = { 'java' }, desc = 'Debug test class' },
        { 'mm', java.test.run_current_method, ft = { 'java' }, desc = 'Run test method' },
        { 'mM', java.test.debug_current_method, ft = { 'java' }, desc = 'Debug test method' },
        { 'mr', java.test.view_last_report, ft = { 'java' }, desc = 'View last report' },
        { 'mu', java.profile.ui, ft = { 'java' }, desc = 'Profile UI' },
      }
    end,
    config = function()
      local java = require 'java'

      java.setup()
      require('lspconfig').jdtls.setup {}

      require('which-key').register { [Leader .. 'm'] = { name = '+major' } }
    end,
  },
  {
    'scalameta/nvim-metals', -- Scala support.
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt' },
    keys = function()
      local metals = require 'metals'
      local tvp = require 'metals.tvp'

      return {
        {
          'mx',
          function() require('telescope').extensions.metals.commands() end,
          ft = { 'scala', 'sbt' },
          desc = 'Metals commands',
        },

        { 'mh', ':MetalsSuperMethodHierarchy<CR>', ft = { 'scala', 'sbt' }, desc = 'Method hierarchy' },
        { 'ma', ':MetalsAnalyzeStacktrace<CR>', ft = { 'scala', 'sbt' }, desc = 'Analyze stacktrace' },

        { 'mo', ':MetalsOrganizeImports<CR>', ft = { 'scala', 'sbt' }, desc = 'Organize imports' },

        { 'mns', ':MetalsNewScalaFile<CR>', ft = { 'scala', 'sbt' }, desc = 'New Scala file' },
        { 'mnj', ':MetalsNewJavaFile<CR>', ft = { 'scala', 'sbt' }, desc = 'New Java file' },

        { 'mwh', metals.hover_worksheet, ft = { 'scala', 'sbt' }, desc = 'Hover expression' },
        { 'mwy', ':MetalsCopyWorksheetOutput<CR>', ft = { 'scala', 'sbt' }, desc = 'Yank worksheet output' },
        { 'mwq', ':MetalsQuickWorksheet<CR>', ft = { 'scala', 'sbt' }, desc = 'Create/toggle quick worksheet' },

        { 'mts', tvp.toggle_tree_view, ft = { 'scala', 'sbt' }, desc = 'Toggle project tree view' },
        { 'mtj', tvp.reveal_in_tree, ft = { 'scala', 'sbt' }, desc = 'Reveal file in project tree' },
        { 'mtt', tvp.toggle_node, ft = { 'scala', 'sbt' }, desc = 'Toggle node' },
        { 'mtc', tvp.node_command, ft = { 'scala', 'sbt' }, desc = 'Node command' },
      }
    end,
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
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvimMetals', { clear = true }),
        -- pattern = { 'scala', 'sbt', 'java' }, -- If basic Java support is required
        pattern = { 'scala', 'sbt' },
        callback = function() metals.initialize_or_attach(metals_cfg) end,
        desc = 'Set Metals up',
      })

      require('which-key').register {
        [Leader .. 'm'] = {
          name = '+major',
          n = { name = '+new' },
          t = { name = '+tvp' },
          w = { name = '+worksheet' },
        },
      }
    end,
  },
}
