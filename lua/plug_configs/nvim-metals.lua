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

SetG('n', 'mx', function() require('telescope').extensions.metals.commands() end, { desc = 'Metals commands' })

SetG('n', 'mh', ':MetalsSuperMethodHierarchy<CR>', { desc = 'Method hierarchy' })
SetG('n', 'ma', ':MetalsAnalyzeStacktrace<CR>', { desc = 'Analyze stacktrace' })

SetG('n', 'mo', ':MetalsOrganizeImports<CR>', { desc = 'Organize imports' })

SetG('n', 'mns', ':MetalsNewScalaFile<CR>', { desc = 'New Scala file' })
SetG('n', 'mnj', ':MetalsNewJavaFile<CR>', { desc = 'New Java file' })

SetG('n', 'mwh', metals.hover_worksheet, { desc = 'Hover expression' })
SetG('n', 'mwy', ':MetalsCopyWorksheetOutput<CR>', { desc = 'Yank worksheet output' })
SetG('n', 'mwq', ':MetalsQuickWorksheet<CR>', { desc = 'Create/toggle quick worksheet' })

local tvp = require("metals.tvp")

SetG('n', 'mts', tvp.toggle_tree_view, { desc = 'Toggle project tree view' })
SetG('n', 'mtj', tvp.reveal_in_tree, { desc = 'Reveal file in project tree' })
SetG('n', 'mtt', tvp.toggle_node, { desc = 'Toggle node' })
SetG('n', 'mtc', tvp.node_command, { desc = 'Node command' })
