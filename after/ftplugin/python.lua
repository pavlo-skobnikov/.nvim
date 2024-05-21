local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'
local dap_py = require 'dap-python'

dap_py.setup(debugpy_path)

vim.keymap.set('n', 'crmc', dap_py.test_class, { desc = 'Test class' })
vim.keymap.set('n', 'crmn', dap_py.test_method, { desc = 'Test nearest method' })
vim.keymap.set({ 'v', 'x' }, 'crms', dap_py.debug_selection, { desc = 'Test selection' })
