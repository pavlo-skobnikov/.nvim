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
vim.keymap.set('n', '<leader>dd', dap_ui.toggle, { desc = 'DAP UI' })
vim.keymap.set('n', '<leader>do', dap.repl.open, { desc = 'Open REPL' })
-- Run.
vim.keymap.set('n', '<leader>drc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>drr', dap.run_last, { desc = 'Run last' })
-- Step.
vim.keymap.set('n', '<leader>dsn', dap.step_over, { desc = 'Step Next' })
vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = 'Step Into' })
vim.keymap.set('n', '<leader>dso', dap.step_out, { desc = 'Step Out' })
-- Breakpoints.
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
-- Find DAP-related things.
vim.keymap.set('n', '<leader>dfc', dap_telescope.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader>dfg', dap_telescope.configurations, { desc = 'Configurations' })
vim.keymap.set('n', '<leader>dfb', dap_telescope.list_breakpoints, { desc = 'Breakpoints' })
vim.keymap.set('n', '<leader>dfv', dap_telescope.variables, { desc = 'Variables' })
vim.keymap.set('n', '<leader>dff', dap_telescope.frames, { desc = 'Frames' })
-- Widgets.
vim.keymap.set({ 'n', 'v' }, '<leader>dwh', dap_widgets.hover, { desc = 'Hover' })
vim.keymap.set({ 'n', 'v' }, '<leader>dwp', dap_widgets.preview, { desc = 'Preview' })
vim.keymap.set('n', '<leader>dwf', function() dap_widgets.centered_float(dap_widgets.frames) end, { desc = 'Frames' })
vim.keymap.set('n', '<leader>dws', function() dap_widgets.centered_float(dap_widgets.scopes) end, { desc = 'Scopes' })
