---@diagnostic disable: undefined-field
-- Searching for symbols, typing them, formatting files, and writing code correctly on the first
-- go is too hard 🌚
return {
  {
    -- Language-agnostic support plugins.
    'hrsh7th/nvim-cmp', -- Autocompletion plugin ✅
    dependencies = {
      -- Core.
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
      'onsails/lspkind-nvim',
      -- Sources
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'rcarriga/cmp-dap',
      'petertriho/cmp-git',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local luasnip = require 'luasnip'

      -- Setup lspkind.
      lspkind.init()

      -- Setup cmp.
      local cmp_mappping_override = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<TAB>'] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          { 'i', 's', 'c' }
        ),
      }

      cmp.setup {
        -- Set source priority for appearing in completion prompts.
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer', keyword_length = 4 },
        },

        -- Set up key mappings for completion.
        mapping = cmp.mapping.preset.insert(cmp_mappping_override),

        -- Enable luasnip to handle snippet expansion for nvim-cmp.
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },

        -- Set up cmp-dap integration.
        enabled = function()
          return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
        end,
      }

      -- Context-aware completion sources setup
      cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
      })
      cmp.setup.filetype(
        { 'dap-repl', 'dapui_watches', 'dapui_hover' },
        { mapping = cmp.mapping.preset.insert(cmp_mappping_override), sources = { { name = 'dap' } } }
      )
      cmp.setup.filetype('gitcommit', {
        mapping = cmp.mapping.preset.insert(cmp_mappping_override),
        sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } }),
      })

      -- Set up luasnip.
      luasnip.config.set_config {
        history = false,
        updateevents = 'TextChanged,TextChangedI',
      }

      -- Snippet traversal mappings.
      Set({ 'i', 's' }, '<C-n>', function() return luasnip.jump(1) end, { silent = true })
      Set({ 'i', 's' }, '<C-p>', function() return luasnip.jump(-1) end, { silent = true })
    end,
  },
  {
    'mhartington/formatter.nvim', -- Easy formatter setup goodness.
    keys = {
      { '=', '<CMD>FormatWrite<CR>', mode = { 'n', 'v' }, desc = 'Format & write' },
    },
    opts = function()
      local function get_ft_formatter(ft, formatter) return { require('formatter.filetypes.' .. ft)[formatter] } end
      local function get_buffer_fname() return vim.api.nvim_buf_get_name(0) end

      local prettier_formatter = { require 'formatter.defaults.prettier' }

      return {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = get_ft_formatter('lua', 'stylua'),
          java = {
            function() return { exe = 'google-java-format', args = { '-a', get_buffer_fname() }, stdin = true } end,
          },
          kotlin = get_ft_formatter('kotlin', 'ktlint'),
          scala = { function() pcall(vim.lsp.buf.format) end },
          javascript = prettier_formatter,
          typescript = prettier_formatter,
          sh = get_ft_formatter('sh', 'shfmt'),
          bash = get_ft_formatter('sh', 'shfmt'),
          zsh = get_ft_formatter('sh', 'shfmt'),
          markdown = prettier_formatter,
          sql = prettier_formatter,
          yaml = prettier_formatter,
          json = prettier_formatter,
          ['*'] = get_ft_formatter('any', 'remove_trailing_whitespace'),
        },
      }
    end,
    config = function(_, opts) require('formatter.init').setup(opts) end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Allows to programmatically define required tools for Mason.
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Easy language server and other tools management.
      'neovim/nvim-lspconfig', -- LSP configuration galore.
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'VeryLazy',
    config = function()
      require('mason').setup()
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require('mason-tool-installer').setup {
        ensure_installed = {
          -- Lua
          'lua-language-server',
          'stylua',
          -- Kotlin
          'kotlin-language-server',
          'kotlin-debug-adapter',
          'ktlint',
          -- HTML
          'html-lsp',
          'emmet-language-server',
          -- CSS
          'css-lsp',
          'tailwindcss-language-server',
          'stylelint',
          -- JavaScript
          'typescript-language-server',
          'eslint-lsp',
          -- Other tools
          'prettier',
        },

        integrations = {
          ['mason-lspconfig'] = false,
          ['mason-null-ls'] = false,
          ['mason-nvim-dap'] = false,
        },
      }

      -- Setup LSP for Mason-managed servers
      lspconfig.lua_ls.setup { capabilities = capabilities }

      lspconfig.kotlin_language_server.setup { capabilities = capabilities }

      lspconfig.html.setup { capabilities = capabilities }
      lspconfig.emmet_language_server.setup { capabilities = capabilities }

      lspconfig.cssls.setup { capabilities = capabilities }
      lspconfig.tailwindcss.setup { capabilities = capabilities }

      lspconfig.tsserver.setup { capabilities = capabilities }
      lspconfig.eslint.setup { capabilities = capabilities }
    end,
  },
  {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client.
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = function()
      local dap = require 'dap'
      local dap_ui = require 'dapui'
      local dap_widgets = require 'dap.ui.widgets'
      local dap_telescope = require('telescope').extensions.dap

      return {
        -- Basic DAP keybindings.
        { Leader .. 'dd', dap_ui.toggle, desc = 'DAP UI' },
        { Leader .. 'do', dap.repl.open, desc = 'Open REPL' },
        -- Run.
        { Leader .. 'drc', dap.continue, desc = 'Continue' },
        { Leader .. 'drr', dap.run_last, desc = 'Run last' },
        -- Step.
        { Leader .. 'dsn', dap.step_over, desc = 'Step Next' },
        { Leader .. 'dsi', dap.step_into, desc = 'Step Into' },
        { Leader .. 'dso', dap.step_out, desc = 'Step Out' },
        -- Breakpoints.
        { Leader .. 'dbb', dap.toggle_breakpoint, desc = 'Toggle breakpoint' },
        {
          'dbc',
          function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
          desc = 'Toggle conditional breakpoint',
        },
        {
          'dbl',
          function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
          desc = 'Toggle log point',
        },
        -- Find DAP-related things.
        { Leader .. 'dfc', dap_telescope.commands, desc = 'Commands' },
        { Leader .. 'dfg', dap_telescope.configurations, desc = 'Configurations' },
        { Leader .. 'dfb', dap_telescope.list_breakpoints, desc = 'Breakpoints' },
        { Leader .. 'dfv', dap_telescope.variables, desc = 'Variables' },
        { Leader .. 'dff', dap_telescope.frames, desc = 'Frames' },
        -- Widgets.
        { Leader .. 'dwh', dap_widgets.hover, desc = 'Hover' },
        { Leader .. 'dwp', dap_widgets.preview, desc = 'Preview' },
        { Leader .. 'dwf', function() dap_widgets.centered_float(dap_widgets.frames) end, desc = 'Frames' },
        { Leader .. 'dws', function() dap_widgets.centered_float(dap_widgets.scopes) end, desc = 'Scopes' },
      }
    end,
    config = function()
      local dap_ui = require 'dapui'
      local dap_virtual_text = require 'nvim-dap-virtual-text'

      -- Redefine DAP signs.
      local function set_dap_sign(name, sign)
        vim.fn.sign_define(name, { text = sign, texthl = '', linehl = '', numhl = '' })
      end

      set_dap_sign('DapBreakpoint', '🛑')
      set_dap_sign('DapBreakpointCondition', '🟥')
      set_dap_sign('DapLogPoint', '📍')
      set_dap_sign('DapStopped', '🧲')
      set_dap_sign('DapBreakpointRejected', '❌')

      -- Setup extension plugins for DAP & Telescope.
      dap_ui.setup()
      dap_virtual_text.setup {}
      require('telescope').load_extension 'dap'
    end,
  },
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
