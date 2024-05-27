local dap = require 'dap'
local dap_ui = require 'dapui'
local dap_widgets = require 'dap.ui.widgets'
local dap_telescope = require('telescope').extensions.dap
local dap_virtual_text = require 'nvim-dap-virtual-text'

-- Redefine DAP signs.
local function set_dap_sign(name, sign) vim.fn.sign_define(name, { text = sign, texthl = '', linehl = '', numhl = '' }) end

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
