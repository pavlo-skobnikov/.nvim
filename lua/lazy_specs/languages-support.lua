-- Typing is too hard 🌚
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
      vim.keymap.set({ 'i', 's' }, '<C-l>', function() return luasnip.jump(1) end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-h>', function() return luasnip.jump(-1) end, { silent = true })
    end,
  },
  {
    'mhartington/formatter.nvim', -- Easy formatter setup goodness.
    event = 'VeryLazy',
    config = function()
      local function get_ft_formatter(ft, formatter) return { require('formatter.filetypes.' .. ft)[formatter] } end
      local function get_buffer_fname() return vim.api.nvim_buf_get_name(0) end

      local prettier_formatter = { require 'formatter.defaults.prettier' }

      require('formatter.init').setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          c = get_ft_formatter('c', 'clangformat'),
          lua = get_ft_formatter('lua', 'stylua'),
          python = get_ft_formatter('python', 'black'),
          go = get_ft_formatter('go', 'goimports'),
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

      Set({ 'n', 'v' }, '=', '<CMD>FormatWrite<CR>', { desc = 'Format & write' })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin.
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' },
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'VeryLazy',
    config = function()
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
    event = 'VeryLazy',
    config = function()
      local dap = require 'dap'
      local dap_ui = require 'dapui'
      local dap_widgets = require 'dap.ui.widgets'
      local dap_telescope = require('telescope').extensions.dap
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

      -- Basic DAP keybindings.
      SetG('n', 'dd', dap_ui.toggle, { desc = 'DAP UI' })
      SetG('n', 'do', dap.repl.open, { desc = 'Open REPL' })
      -- Run.
      SetG('n', 'drc', dap.continue, { desc = 'Continue' })
      SetG('n', 'drr', dap.run_last, { desc = 'Run last' })
      -- Step.
      SetG('n', 'dsn', dap.step_over, { desc = 'Step Next' })
      SetG('n', 'dsi', dap.step_into, { desc = 'Step Into' })
      SetG('n', 'dso', dap.step_out, { desc = 'Step Out' })
      -- Breakpoints.
      SetG('n', 'dbb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      SetG(
        'n',
        'dbc',
        function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        { desc = 'Toggle conditional breakpoint' }
      )
      SetG(
        'n',
        'dbl',
        function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
        { desc = 'Toggle log point' }
      )
      -- Find DAP-related things.
      SetG('n', 'dfc', dap_telescope.commands, { desc = 'Commands' })
      SetG('n', 'dfg', dap_telescope.configurations, { desc = 'Configurations' })
      SetG('n', 'dfb', dap_telescope.list_breakpoints, { desc = 'Breakpoints' })
      SetG('n', 'dfv', dap_telescope.variables, { desc = 'Variables' })
      SetG('n', 'dff', dap_telescope.frames, { desc = 'Frames' })
      -- Widgets.
      SetG({ 'n', 'v' }, 'dwh', dap_widgets.hover, { desc = 'Hover' })
      SetG({ 'n', 'v' }, 'dwp', dap_widgets.preview, { desc = 'Preview' })
      SetG('n', 'dwf', function() dap_widgets.centered_float(dap_widgets.frames) end, { desc = 'Frames' })
      SetG('n', 'dws', function() dap_widgets.centered_float(dap_widgets.scopes) end, { desc = 'Scopes' })
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
    config = function()
      local java = require 'java'

      java.setup()
      require('lspconfig').jdtls.setup {}

      SetG('n', 'mr', java.runner.built_in.run_app, { desc = 'Run' })
      SetG('n', 'mR', function()
        local input = vim.fn.input 'App arguments: '

        -- Convert the input string into a table of arguments
        local arguments = {}
        for arg in string.gmatch(input, '%S+') do
          table.insert(arguments, arg)
        end

        java.runner.built_in.run_app(arguments)
      end, { desc = 'Run with arguments' })
      SetG('n', 'ms', java.runner.built_in.stop_app, { desc = 'Stop' })
      SetG('n', 'ml', java.runner.built_in.toggle_logs, { desc = 'Toggle logs' })
      SetG('n', 'md', java.dap.config_dap, { desc = 'Configure DAP' })
      SetG('n', 'mc', java.test.run_current_class, { desc = 'Run class' })
      SetG('n', 'mC', java.test.debug_current_class, { desc = 'Debug class' })
      SetG('n', 'mm', java.test.run_current_method, { desc = 'Run method' })
      SetG('n', 'mM', java.test.debug_current_method, { desc = 'Debug method' })
      SetG('n', 'mr', java.test.view_last_report, { desc = 'View last report' })
      SetG('n', 'mu', java.profile.ui, { desc = 'Profile UI' })
    end,
  },
  {
    'scalameta/nvim-metals', -- Scala support.
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

      local tvp = require 'metals.tvp'

      SetG('n', 'mts', tvp.toggle_tree_view, { desc = 'Toggle project tree view' })
      SetG('n', 'mtj', tvp.reveal_in_tree, { desc = 'Reveal file in project tree' })
      SetG('n', 'mtt', tvp.toggle_node, { desc = 'Toggle node' })
      SetG('n', 'mtc', tvp.node_command, { desc = 'Node command' })
    end,
  },
}
