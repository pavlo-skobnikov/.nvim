local java = require 'java'

java.setup()
require('lspconfig').jdtls.setup {}

vim.keymap.set('n', 'crmr', java.runner.built_in.run_app, { desc = 'Run' })
vim.keymap.set('n', 'crmR', function()
  local input = vim.fn.input 'App arguments: '

  -- Convert the input string into a table of arguments
  local arguments = {}
  for arg in string.gmatch(input, '%S+') do
    table.insert(arguments, arg)
  end

  java.runner.built_in.run_app(arguments)
end, { desc = 'Run with arguments' })
vim.keymap.set('n', 'crms', java.runner.built_in.stop_app, { desc = 'Stop' })
vim.keymap.set('n', 'crml', java.runner.built_in.toggle_logs, { desc = 'Toggle logs' })
vim.keymap.set('n', 'crmd', java.dap.config_dap, { desc = 'Configure DAP' })
vim.keymap.set('n', 'crmc', java.test.run_current_class, { desc = 'Run class' })
vim.keymap.set('n', 'crmC', java.test.debug_current_class, { desc = 'Debug class' })
vim.keymap.set('n', 'crmm', java.test.run_current_method, { desc = 'Run method' })
vim.keymap.set('n', 'crmM', java.test.debug_current_method, { desc = 'Debug method' })
vim.keymap.set('n', 'crmr', java.test.view_last_report, { desc = 'View last report' })
vim.keymap.set('n', 'crmu', java.profile.ui, { desc = 'Profile UI' })
