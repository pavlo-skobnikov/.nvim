---@diagnostic disable: undefined-field
-- Debug Adapter Protocol support 🐛
return {
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
      { '<LEADER>dd', dap_ui.toggle, desc = 'DAP UI' },
      { '<LEADER>do', dap.repl.open, desc = 'Open REPL' },
      -- Run.
      { '<LEADER>drc', dap.continue, desc = 'Continue' },
      { '<LEADER>drr', dap.run_last, desc = 'Run last' },
      -- Step.
      { '<LEADER>dsn', dap.step_over, desc = 'Step Next' },
      { '<LEADER>dsi', dap.step_into, desc = 'Step Into' },
      { '<LEADER>dso', dap.step_out, desc = 'Step Out' },
      -- Breakpoints.
      { '<LEADER>dbb', dap.toggle_breakpoint, desc = 'Toggle breakpoint' },
      {
        '<LEADER>dbc',
        function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'Toggle conditional breakpoint',
      },
      {
        '<LEADER>dbl',
        function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
        desc = 'Toggle log point',
      },
      -- Find DAP-related things.
      { '<LEADER>dfc', dap_telescope.commands, desc = 'Commands' },
      { '<LEADER>dfg', dap_telescope.configurations, desc = 'Configurations' },
      { '<LEADER>dfb', dap_telescope.list_breakpoints, desc = 'Breakpoints' },
      { '<LEADER>dfv', dap_telescope.variables, desc = 'Variables' },
      { '<LEADER>dff', dap_telescope.frames, desc = 'Frames' },
      -- Widgets.
      { '<LEADER>dwh', dap_widgets.hover, desc = 'Hover' },
      { '<LEADER>dwp', dap_widgets.preview, desc = 'Preview' },
      { '<LEADER>dwf', function() dap_widgets.centered_float(dap_widgets.frames) end, desc = 'Frames' },
      { '<LEADER>dws', function() dap_widgets.centered_float(dap_widgets.scopes) end, desc = 'Scopes' },
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
}
