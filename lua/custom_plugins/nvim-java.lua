-- Boilerplate-driven development 😪
return {
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

          -- Convert the input string into a table of arguments.
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
}
