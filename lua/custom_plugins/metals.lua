-- Incredible Scala support 🤯
return {
  'scalameta/nvim-metals',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
  ft = { 'scala', 'sbt' },
  keys = function()
    local metals = require 'metals'
    local tvp = require 'metals.tvp'

    return {
      {
        '<LOCALLEADER>x',
        function() require('telescope').extensions.metals.commands() end,
        ft = { 'scala', 'sbt' },
        desc = 'Metals commands',
      },

      { '<LOCALLEADER>h', ':MetalsSuperMethodHierarchy<CR>', ft = { 'scala', 'sbt' }, desc = 'Method hierarchy' },
      { '<LOCALLEADER>a', ':MetalsAnalyzeStacktrace<CR>', ft = { 'scala', 'sbt' }, desc = 'Analyze stacktrace' },

      { '<LOCALLEADER>o', ':MetalsOrganizeImports<CR>', ft = { 'scala', 'sbt' }, desc = 'Organize imports' },

      { '<LOCALLEADER>ns', ':MetalsNewScalaFile<CR>', ft = { 'scala', 'sbt' }, desc = 'New Scala file' },
      { '<LOCALLEADER>nj', ':MetalsNewJavaFile<CR>', ft = { 'scala', 'sbt' }, desc = 'New Java file' },

      { '<LOCALLEADER>wh', metals.hover_worksheet, ft = { 'scala', 'sbt' }, desc = 'Hover expression' },
      { '<LOCALLEADER>wy', ':MetalsCopyWorksheetOutput<CR>', ft = { 'scala', 'sbt' }, desc = 'Yank worksheet output' },
      {
        '<LOCALLEADER>wq',
        ':MetalsQuickWorksheet<CR>',
        ft = { 'scala', 'sbt' },
        desc = 'Create/toggle quick worksheet',
      },

      { '<LOCALLEADER>ts', tvp.toggle_tree_view, ft = { 'scala', 'sbt' }, desc = 'Toggle project tree view' },
      { '<LOCALLEADER>tj', tvp.reveal_in_tree, ft = { 'scala', 'sbt' }, desc = 'Reveal file in project tree' },
      { '<LOCALLEADER>tt', tvp.toggle_node, ft = { 'scala', 'sbt' }, desc = 'Toggle node' },
      { '<LOCALLEADER>tc', tvp.node_command, ft = { 'scala', 'sbt' }, desc = 'Node command' },
    }
  end,
  config = function()
    local metals = require 'metals'
    local metals_cfg = metals.bare_config()
    local dap = require 'dap'

    metals_cfg.on_attach = function()
      -- Metals-specific configurations.
      metals_cfg.init_options.statusBarProvider = 'on'
      metals_cfg.settings = {
        showImplicitArguments = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
      }

      -- Setup capabilites for `cmp` snippets.
      metals_cfg.capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Add a Scala DAP client.
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
      -- pattern = { 'scala', 'sbt', 'java' }, -- If basic Java support is required.
      pattern = { 'scala', 'sbt' },
      callback = function() metals.initialize_or_attach(metals_cfg) end,
      desc = 'Set Metals up',
    })

    require('which-key').register {
      ['<LOCALLEADER>'] = {
        n = { name = '+new' },
        t = { name = '+tvp' },
        w = { name = '+worksheet' },
      },
    }
  end,
}
