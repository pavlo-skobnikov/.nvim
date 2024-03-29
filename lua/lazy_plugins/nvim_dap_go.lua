return {
  'leoluz/nvim-dap-go', -- Debug Adapter for Go
  dependencies = { 'mfussenegger/nvim-dap', 'folke/which-key.nvim' },
  ft = { 'go' },
  config = function()
    local dap_go = require 'dap-go'

    dap_go.setup()

    UTIL.register_keys {
      ['<leader>m'] = {
        name = 'major',
        n = { dap_go.debug_test, 'Test nearest' },
        l = { dap_go.debug_last_test, 'Test last' },
      },
    }
  end,
}
