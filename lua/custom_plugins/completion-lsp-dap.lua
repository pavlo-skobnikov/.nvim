---@diagnostic disable: undefined-field
-- Searching for symbols, typing them, formatting files, and writing code correctly on the first
-- try is too hard 🌚
return {
  { -- Autocompletion plugin ✅
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Core.
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
      'onsails/lspkind-nvim',
      -- Completion sources.
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
  { -- Allows to programmatically define required tools for Mason.
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Easy language server and other tools management.
      'neovim/nvim-lspconfig', -- LSP configuration galore.
      'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with nvim-lspconfig.
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'VeryLazy',
    config = function()
      require('mason').setup()
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

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers {
        function(server_name) -- Default handler for setting up LSP servers.
          require('lspconfig')[server_name].setup {
            capabilities = vim.tbl_deep_extend(
              'force',
              {},
              vim.lsp.protocol.make_client_capabilities(),
              require('cmp_nvim_lsp').default_capabilities()
            ),
          }
        end,
        ['jdtls'] = function() end, -- nvim-java handles the setup on its own.
      }
    end,
  },
  { -- Support for linting tools that are not LSP-based 🌤️
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { Leader .. 'L', function() require('lint').try_lint() end, desc = 'Lint the current buffer' },
    },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        kotlin = { 'ktlint' },
        css = { 'stylelint' },
        sass = { 'stylelint' },
        scss = { 'stylelint' },
        less = { 'stylelint' },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('LintCurrentBuffer', { clear = true }),
        callback = function() require('lint').try_lint() end,
        desc = 'Lint the current buffer',
      })
    end,
  },
  { -- Let's keep the code nice and tidy 🧹
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
      },
      -- Arguments that are passed to conform.format()
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  { -- Debug Adapter Protocol support.
    'mfussenegger/nvim-dap',
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
}
