---@diagnostic disable: undefined-field
return {
  {
    'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Package manager for Neovim
      'neovim/nvim-lspconfig', -- Configs for the Nvim LSP client (:help lsp)
      'hrsh7th/cmp-nvim-lsp', -- LSP completion source for nvim-cmp
    },
    ft = {
      'c',
      'zig',
      'rust',
      'lua',
      'python',
      'go',
      'java',
      'kotlin',
      'clojure',
      'javascript',
      'typescript',
      'bash',
      'markdown',
      'dockerfile',
      'docker-compose',
      'sql',
      'yaml',
      'json',
    },
    config = function()
      -- Setup Mason for package management
      require('mason').setup()

      local mason_config = require 'mason-lspconfig.init'
      local lsp_config = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup Mason LSP config
      mason_config.setup {
        ensure_installed = {
          'clangd', -- C
          'zls', -- Zig
          'rust_analyzer', -- Rust
          'lua_ls', -- Lua
          'pylsp', -- Python
          'gopls', -- Go
          'jdtls', -- Java
          'kotlin_language_server', -- Kotlin
          'clojure_lsp', -- Clojure
          -- Scala & Metals are not managed by Mason :)
          -- Gleam isn't managed by Mason either!
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
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client
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
        -- Basic DAP keybindings
        { '<leader>dd', dap_ui.toggle, desc = 'DAP UI' },
        { '<leader>do', dap.repl.open, desc = 'Open REPL' },
        -- Run
        { '<leader>drc', dap.continue, desc = 'Continue' },
        { '<leader>drr', dap.run_last, desc = 'Run last' },
        -- Step
        { '<leader>dsn', dap.step_over, desc = 'Step Next' },
        { '<leader>dsi', dap.step_into, desc = 'Step Into' },
        { '<leader>dso', dap.step_out, desc = 'Step Out' },
        -- Breakpoints
        { '<leader>dbb', dap.toggle_breakpoint, desc = 'Toggle breakpoint' },
        {
          '<leader>dbc',
          function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
          desc = 'Toggle conditional breakpoint',
        },
        {
          '<leader>dbl',
          function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
          desc = 'Toggle log point',
        },
        -- Find DAP-related things
        { '<leader>dfc', dap_telescope.commands, desc = 'Commands' },
        { '<leader>dfg', dap_telescope.configurations, desc = 'Configurations' },
        { '<leader>dfb', dap_telescope.list_breakpoints, desc = 'Breakpoints' },
        { '<leader>dfv', dap_telescope.variables, desc = 'Variables' },
        { '<leader>dff', dap_telescope.frames, desc = 'Frames' },
        -- Widgets
        { '<leader>dwh', dap_widgets.hover, mode = { 'n', 'v' }, desc = 'Hover' },
        { '<leader>dwp', dap_widgets.preview, mode = { 'n', 'v' }, desc = 'Preview' },
        { '<leader>dwf', function() dap_widgets.centered_float(dap_widgets.frames) end, desc = 'Frames' },
        { '<leader>dws', function() dap_widgets.centered_float(dap_widgets.scopes) end, desc = 'Scopes' },
      }
    end,
    config = function()
      -- Redefine DAP signs
      local function set_dap_sign(name, sign)
        vim.fn.sign_define(name, { text = sign, texthl = '', linehl = '', numhl = '' })
      end

      set_dap_sign('DapBreakpoint', '🛑')
      set_dap_sign('DapBreakpointCondition', '🟥')
      set_dap_sign('DapLogPoint', '📍')
      set_dap_sign('DapStopped', '🧲')
      set_dap_sign('DapBreakpointRejected', '❌')

      -- Register DAP listeners for automatic opening/closing of DAP UI
      local dap_listeners = require('dap').listeners
      local dap_ui = require 'dapui'
      local dap_virtual_text = require 'nvim-dap-virtual-text'

      dap_listeners.after.event_initialized['dapui_config'] = dap_ui.open
      dap_listeners.before.event_terminated['dapui_config'] = dap_ui.close
      dap_listeners.before.event_exited['dapui_config'] = dap_ui.close

      -- Setup extension plugins for DAP & Telescope
      dap_ui.setup()
      dap_virtual_text.setup {}
      require('telescope').load_extension 'dap'
    end,
  },
}
