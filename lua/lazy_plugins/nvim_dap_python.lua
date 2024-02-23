return {
  'mfussenegger/nvim-dap-python', -- Debug Adapter for Python
  dependencies = { 'mfussenegger/nvim-dap', 'folke/which-key.nvim' },
  ft = { 'python' },
  config = function()
    local dap_py = require 'dap-python'

    local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'

    dap_py.setup(debugpy_path)

    UTIL.register_keys {
      ['<leader>m'] = {
        name = 'major',
        c = { dap_py.test_class, 'Test class' },
        n = { dap_py.test_method, 'Test nearest' },
        s = { dap_py.debug_selection, 'Test selection' },
      },
    }
  end,
}
