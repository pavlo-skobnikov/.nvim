return {
   'github/copilot.vim', -- AI-powered code completion
   event = 'InsertEnter',
   config = function()
      vim.g.copilot_no_tab_map = true
      PG.reg_wk({
         ['<c-s-y>'] = { 'copilot#Accept("\\<CR>")', 'Accept Copilot suggestion' },
      }, {
         silent = true,
         expr = true,
         script = true,
         replace_keycodes = false,
         mode = 'i',
      })

      PG.reg_wk({
         ['<leader>c'] = { ':Copilot panel<CR>', 'Open Copilot' },
         ['yoC'] = {
            function()
               local status = vim.api.nvim_command_output('Copilot status')

               if string.find(status, 'Enabled') or string.find(status, 'enabled') then
                  vim.api.nvim_command('Copilot disable')
               else
                  vim.api.nvim_command('Copilot enable')
               end
            end,
            'Copilot',
         },
      })
   end,
}
