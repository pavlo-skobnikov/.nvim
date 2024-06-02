local java = require 'java'

java.setup()
require('lspconfig').jdtls.setup {}

SetG('n', 'mr', java.runner.built_in.run_app, { desc = 'Run' })
SetG('n', 'mR', function()
  local input = vim.fn.input 'App arguments: '

  -- Convert the input string into a table of arguments
  local arguments = {}
  for arg in string.gmatch(input, '%S+') do
    table.insert(arguments, arg)
  end

  java.runner.built_in.run_app(arguments)
end, { desc = 'Run with arguments' })
SetG('n', 'ms', java.runner.built_in.stop_app, { desc = 'Stop' })
SetG('n', 'ml', java.runner.built_in.toggle_logs, { desc = 'Toggle logs' })
SetG('n', 'md', java.dap.config_dap, { desc = 'Configure DAP' })
SetG('n', 'mc', java.test.run_current_class, { desc = 'Run class' })
SetG('n', 'mC', java.test.debug_current_class, { desc = 'Debug class' })
SetG('n', 'mm', java.test.run_current_method, { desc = 'Run method' })
SetG('n', 'mM', java.test.debug_current_method, { desc = 'Debug method' })
SetG('n', 'mr', java.test.view_last_report, { desc = 'View last report' })
SetG('n', 'mu', java.profile.ui, { desc = 'Profile UI' })
