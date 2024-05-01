return {
  {
    'ray-x/go.nvim', -- Go support
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-treesitter/nvim-treesitter', 'ray-x/guihua.lua' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    config = function() require('go').setup() end,
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
        opts = { registries = { 'github:nvim-java/mason-registry', 'github:mason-org/mason-registry' } },
      },
    },
    ft = { 'java' },
    keys = function()
      local java = require 'java'

      return {
        { 'crmr', java.runner.built_in.run_app, ft = 'java', desc = 'Run' },
        {
          'crmR',
          function()
            local input = vim.fn.input 'App arguments: '

            -- Convert the input string into a table of arguments
            local arguments = {}
            for arg in string.gmatch(input, '%S+') do
              table.insert(arguments, arg)
            end

            java.runner.built_in.run_app(arguments)
          end,
          ft = 'java',
          desc = 'Run with arguments',
        },
        { 'crms', java.runner.built_in.stop_app, ft = 'java', desc = 'Stop' },
        { 'crml', java.runner.built_in.toggle_logs, ft = 'java', desc = 'Toggle logs' },
        { 'crmd', java.dap.config_dap, ft = 'java', desc = 'Configure DAP' },
        { 'crmc', java.test.run_current_class, ft = 'java', desc = 'Run class' },
        { 'crmC', java.test.debug_current_class, ft = 'java', desc = 'Debug class' },
        { 'crmm', java.test.run_current_method, ft = 'java', desc = 'Run method' },
        { 'crmM', java.test.debug_current_method, ft = 'java', desc = 'Debug method' },
        { 'crmr', java.test.view_last_report, ft = 'java', desc = 'View last report' },
        { 'crmu', java.profile.ui, ft = 'java', desc = 'Profile UI' },
      }
    end,
    config = function()
      require('java').setup()
      require('lspconfig').jdtls.setup {}
    end,
  },
  {
    'mfussenegger/nvim-dap-python', -- Python debugging support
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = { 'python' },
    keys = function()
      local dap_py = require 'dap-python'

      return {
        { 'crmc', dap_py.test_class, ft = 'python', desc = 'Test class' },
        { 'crmn', dap_py.test_method, ft = 'python', desc = 'Test nearest method' },
        { 'crms', dap_py.debug_selection, mode = { 'v', 'x' }, ft = 'python', desc = 'Test selection' },
      }
    end,
    config = function()
      local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'

      require('dap-python').setup(debugpy_path)
    end,
  },
  {
    'scalameta/nvim-metals', -- Scala support
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt' },
    keys = function()
      local metals = require 'metals'

      return { { 'crmw', metals.workspace_open, ft = { 'scala', 'sbt' }, desc = 'Open workspace' } }
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
    end,
  },
}
