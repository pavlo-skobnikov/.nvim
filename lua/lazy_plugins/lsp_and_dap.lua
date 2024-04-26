---@diagnostic disable: undefined-field
return {
  {
    'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' }, -- Package manager for Neovim
      'neovim/nvim-lspconfig', -- Configs for the Nvim LSP client (:help lsp)
      'hrsh7th/cmp-nvim-lsp', -- LSP completion source for nvim-cmp
    },
    event = 'VeryLazy',
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
      'rcarriga/nvim-dap-ui', -- UI for DAP
      'theHamsta/nvim-dap-virtual-text', -- Virtual Text for DAP
      'nvim-telescope/telescope-dap.nvim', -- UI picker extension for DAP
      'nvim-telescope/telescope.nvim',
    },
    event = 'VeryLazy',
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

      -- Requires & aliases
      local dap = require 'dap'
      local dap_listeners = dap.listeners
      local dap_ui = require 'dapui'
      local dap_widgets = require 'dap.ui.widgets'
      local dap_virtual_text = require 'nvim-dap-virtual-text'
      local dap_telescope = require('telescope').extensions.dap

      -- Basic DAP keybindings
      vim.keymap.set('n', '<leader>dd', dap_ui.toggle, { desc = 'DAP UI' })
      vim.keymap.set('n', '<leader>do', dap.repl.open, { desc = 'Open REPL' })
      -- Run
      vim.keymap.set('n', '<leader>drc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>drr', dap.run_last, { desc = 'Run last' })
      -- Step
      vim.keymap.set('n', '<leader>dsn', dap.step_over, { desc = 'Step Next' })
      vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = 'Step Into' })
      vim.keymap.set('n', '<leader>dso', dap.step_out, { desc = 'Step Out' })
      -- Breakpoints
      vim.keymap.set('n', '<leader>dbb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set(
        'n',
        '<leader>dbc',
        function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        { desc = 'Toggle conditional breakpoint' }
      )
      vim.keymap.set(
        'n',
        '<leader>dbl',
        function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
        { desc = 'Toggle log point' }
      )
      -- Find DAP-related things
      vim.keymap.set('n', '<leader>dfc', dap_telescope.commands, { desc = 'Commands' })
      vim.keymap.set('n', '<leader>dfg', dap_telescope.configurations, { desc = 'Configurations' })
      vim.keymap.set('n', '<leader>dfb', dap_telescope.list_breakpoints, { desc = 'Breakpoints' })
      vim.keymap.set('n', '<leader>dfv', dap_telescope.variables, { desc = 'Variables' })
      vim.keymap.set('n', '<leader>dff', dap_telescope.frames, { desc = 'Frames' })
      -- Widgets
      vim.keymap.set({ 'n', 'v' }, '<leader>dwh', dap_widgets.hover, { desc = 'Hover' })
      vim.keymap.set({ 'n', 'v' }, '<leader>dwp', dap_widgets.preview, { desc = 'Preview' })
      vim.keymap.set(
        'n',
        '<leader>dwf',
        function() dap_widgets.centered_float(dap_widgets.frames) end,
        { desc = 'Frames' }
      )
      vim.keymap.set(
        'n',
        '<leader>dws',
        function() dap_widgets.centered_float(dap_widgets.scopes) end,
        { desc = 'Scopes' }
      )

      -- Register DAP listeners for automatic opening/closing of DAP UI
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
