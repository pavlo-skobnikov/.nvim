local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'
local dap_py = require 'dap-python'

dap_py.setup(debugpy_path)

SetG('n', 'mc', dap_py.test_class, { desc = 'Test class' })
SetG('n', 'mn', dap_py.test_method, { desc = 'Test nearest method' })
SetG({ 'v', 'x' }, 'ms', dap_py.debug_selection, { desc = 'Test selection' })
