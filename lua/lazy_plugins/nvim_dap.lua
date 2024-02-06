---@diagnostic disable: undefined-field
return {
  {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client
    dependencies = {
      'rcarriga/nvim-dap-ui', -- UI for DAP
      'theHamsta/nvim-dap-virtual-text', -- Virtual Text for DAP
      'nvim-telescope/telescope-dap.nvim', -- UI picker extension for DAP
      'nvim-telescope/telescope.nvim',
      'folke/which-key.nvim',
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

      -- Setup mappings
      UTIL.register_keys({
        name = 'dap',
        D = { dap_ui.toggle, 'DAP UI' }, -- General mappings
        O = { dap.repl.open, 'Open REPL' },
        C = { dap.continue, 'Continue' },
        R = { dap.run_last, 'Run last' },
        n = { dap.step_over, 'Step Next' }, -- Step mappings
        i = { dap.step_into, 'Step Into' },
        o = { dap.step_out, 'Step Out' },
        b = { dap.toggle_breakpoint, 'Toggle breakpoint' }, -- Breakpoint mappings
        c = {
          function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
          'Toggle conditional breakpoint',
        },
        l = {
          function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
          'Toggle log point',
        },
        f = {
          name = 'find',
          c = { dap_telescope.commands, 'Commands' },
          g = { dap_telescope.configurations, 'Configurations' },
          b = { dap_telescope.list_breakpoints, 'Breakpoints' },
          v = { dap_telescope.variables, 'Variables' },
          f = { dap_telescope.frames, 'Frames' },
        },
      }, { prefix = '<leader>d' })

      UTIL.register_keys({
        name = 'widgets',
        h = { dap_widgets.hover, 'Hover' },
        p = { dap_widgets.preview, 'Preview' },
        f = { function() dap_widgets.centered_float(dap_widgets.frames) end, 'Frames' },
        s = { function() dap_widgets.centered_float(dap_widgets.scopes) end, 'Scopes' },
      }, { mode = { 'n', 'v' }, prefix = '<leader>dw' })

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
