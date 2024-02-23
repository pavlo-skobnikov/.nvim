---@diagnostic disable: undefined-field
return {
  'scalameta/nvim-metals',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
  ft = { 'scala', 'sbt' },
  config = function()
    local metals = require 'metals'
    local metals_cfg = metals.bare_config()
    local dap = require 'dap'

    metals_cfg.on_attach = function(_, _)
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

      -- Set Metals-specific keymaps
      UTIL.register_keys {
        ['<leader>m'] = {
          name = 'major',
          w = { function() metals.hover_worksheet() end, 'Open worksheet' },
        },
      }
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('nvimMetals', { clear = true }),
      -- pattern = { 'scala', 'sbt', 'java' }, -- If basic Java support is required
      pattern = { 'scala', 'sbt' },
      callback = function() metals.initialize_or_attach(metals_cfg) end,
      desc = 'Set Metals up',
    })
  end,
}
