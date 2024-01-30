return {
   'leoluz/nvim-dap-go', -- Debug Adapter for Go
   dependencies = { 'mfussenegger/nvim-dap', 'folke/which-key.nvim' },
   ft = { 'go' },
   config = function()
      local dap_go = require('dap-go')

      dap_go.setup()

      PG.reg_wk({
         name = 'test',
         n = { dap_go.debug_test, 'Nearest' },
         l = { dap_go.debug_last_test, 'Last' },
      }, { prefix = '<leader>dt' })
   end,
}
