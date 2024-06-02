-- 'I' in 'LLM' stands for 'Intelligence' 🧠
return {
  {
    'github/copilot.vim', -- Wait a bit get an average completion suggestion 🕰️
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }
    end,
  },
  {
    'robitx/gp.nvim', -- Proompt engineering 🚀
    event = 'VeryLazy',
    config = function()
      require('gp').setup()

      local function keymapOptions(desc)
        return {
          noremap = true,
          silent = true,
          nowait = true,
          desc = desc,
        }
      end

      -- Chat commands
      SetG({ 'n', 'i' }, 'cc', '<cmd>GpChatNew<cr>', keymapOptions 'New Chat')
      SetG({ 'n', 'i' }, 'ct', '<cmd>GpChatToggle<cr>', keymapOptions 'Toggle Chat')
      SetG({ 'n', 'i' }, 'cf', '<cmd>GpChatFinder<cr>', keymapOptions 'Chat Finder')

      SetG('v', 'cc', ":<C-u>'<,'>GpChatNew<cr>", keymapOptions 'Visual Chat New')
      SetG('v', 'cp', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions 'Visual Chat Paste')
      SetG('v', 'ct', ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions 'Visual Toggle Chat')

      SetG({ 'n', 'i' }, 'c<C-x>', '<cmd>GpChatNew split<cr>', keymapOptions 'New Chat split')
      SetG({ 'n', 'i' }, 'c<C-v>', '<cmd>GpChatNew vsplit<cr>', keymapOptions 'New Chat vsplit')
      SetG({ 'n', 'i' }, 'c<C-t>', '<cmd>GpChatNew tabnew<cr>', keymapOptions 'New Chat tabnew')

      SetG('v', 'c<C-x>', ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions 'Visual Chat New split')
      SetG('v', 'c<C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions 'Visual Chat New vsplit')
      SetG('v', 'c<C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions 'Visual Chat New tabnew')

      -- Prompt commands
      SetG({ 'n', 'i' }, 'cr', '<cmd>GpRewrite<cr>', keymapOptions 'Inline Rewrite')
      SetG({ 'n', 'i' }, 'ca', '<cmd>GpAppend<cr>', keymapOptions 'Append (after)')
      SetG({ 'n', 'i' }, 'cb', '<cmd>GpPrepend<cr>', keymapOptions 'Prepend (before)')

      SetG('v', 'cr', ":<C-u>'<,'>GpRewrite<cr>", keymapOptions 'Visual Rewrite')
      SetG('v', 'ca', ":<C-u>'<,'>GpAppend<cr>", keymapOptions 'Visual Append (after)')
      SetG('v', 'cb', ":<C-u>'<,'>GpPrepend<cr>", keymapOptions 'Visual Prepend (before)')
      SetG('v', 'ci', ":<C-u>'<,'>GpImplement<cr>", keymapOptions 'Implement selection')

      SetG({ 'n', 'i' }, 'cgp', '<cmd>GpPopup<cr>', keymapOptions 'Popup')
      SetG({ 'n', 'i' }, 'cge', '<cmd>GpEnew<cr>', keymapOptions 'GpEnew')
      SetG({ 'n', 'i' }, 'cgn', '<cmd>GpNew<cr>', keymapOptions 'GpNew')
      SetG({ 'n', 'i' }, 'cgv', '<cmd>GpVnew<cr>', keymapOptions 'GpVnew')
      SetG({ 'n', 'i' }, 'cgt', '<cmd>GpTabnew<cr>', keymapOptions 'GpTabnew')

      SetG('v', 'cgp', ":<C-u>'<,'>GpPopup<cr>", keymapOptions 'Visual Popup')
      SetG('v', 'cge', ":<C-u>'<,'>GpEnew<cr>", keymapOptions 'Visual GpEnew')
      SetG('v', 'cgn', ":<C-u>'<,'>GpNew<cr>", keymapOptions 'Visual GpNew')
      SetG('v', 'cgv', ":<C-u>'<,'>GpVnew<cr>", keymapOptions 'Visual GpVnew')
      SetG('v', 'cgt', ":<C-u>'<,'>GpTabnew<cr>", keymapOptions 'Visual GpTabnew')

      SetG({ 'n', 'i' }, 'cx', '<cmd>GpContext<cr>', keymapOptions 'Toggle Context')
      SetG('v', 'cx', ":<C-u>'<,'>GpContext<cr>", keymapOptions 'Visual Toggle Context')

      SetG({ 'n', 'i', 'v', 'x' }, 'cs', '<cmd>GpStop<cr>', keymapOptions 'Stop')
      SetG({ 'n', 'i', 'v', 'x' }, 'cn', '<cmd>GpNextAgent<cr>', keymapOptions 'Next Agent')
    end,
  },
}
