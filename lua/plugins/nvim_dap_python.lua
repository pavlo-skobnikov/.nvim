return {
   'mfussenegger/nvim-dap-python', -- Debug Adapter for Python
   dependencies = { 'mfussenegger/nvim-dap', 'folke/which-key.nvim' },
   ft = { 'python' },
   config = function()
      local dap_py = require('dap-python')

      local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path()
         .. '/venv/bin/python'

      dap_py.setup(debugpy_path)

      PG.reg_wk({
         name = 'test',
         c = { dap_py.test_class, 'Class' },
         n = { dap_py.test_method, 'Nearest' },
         s = { dap_py.debug_selection, 'Selection' },
      }, { prefix = '<leader>dt' })
   end,
}
