return {
  {
    'ray-x/go.nvim', -- Go support
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
      'ray-x/guihua.lua', -- GUI library
    },
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
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
      vim.keymap.set('n', '<leader>mR', function()
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
    'mfussenegger/nvim-dap-python', -- Python debugging support
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = { 'python' },
    config = function()
      local dap_py = require 'dap-python'

      local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'

      dap_py.setup(debugpy_path)

      vim.keymap.set('n', '<leader>mc', dap_py.test_class, { desc = 'Test class' })
      vim.keymap.set('n', '<leader>mn', dap_py.test_method, { desc = 'Test nearest method' })
      vim.keymap.set({ 'v', 'x' }, '<leader>ms', dap_py.debug_selection, { desc = 'Test selection' })
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
