-- 'I' in 'LLM' stands for 'Intelligence' 🧠
return {
  { -- Wait a bit get an average completion suggestion 🕰️
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }
    end,
  },
  { -- Proompt engineering 🚀
    'robitx/gp.nvim',
    keys = function()
      local function create_mapping(mapping, action, mode, desc)
        return { Leader .. mapping, action, mode = mode, noremap = true, silent = true, nowait = true, desc = desc }
      end

      return {
        -- Chat commands
        create_mapping('cc', '<cmd>GpChatNew<cr>', { 'n', 'i' }, 'New Chat'),
        create_mapping('ct', '<cmd>GpChatToggle<cr>', { 'n', 'i' }, 'Toggle Chat'),
        create_mapping('cf', '<cmd>GpChatFinder<cr>', { 'n', 'i' }, 'Chat Finder'),

        create_mapping('cc', ":<C-u>'<,'>GpChatNew<cr>", 'v', 'Visual Chat New'),
        create_mapping('cp', ":<C-u>'<,'>GpChatPaste<cr>", 'v', 'Visual Chat Paste'),
        create_mapping('ct', ":<C-u>'<,'>GpChatToggle<cr>", 'v', 'Visual Toggle Chat'),

        create_mapping('c<C-x>', '<cmd>GpChatNew split<cr>', { 'n', 'i' }, 'New Chat split'),
        create_mapping('c<C-v>', '<cmd>GpChatNew vsplit<cr>', { 'n', 'i' }, 'New Chat vsplit'),
        create_mapping('c<C-t>', '<cmd>GpChatNew tabnew<cr>', { 'n', 'i' }, 'New Chat tabnew'),

        create_mapping('c<C-x>', ":<C-u>'<,'>GpChatNew split<cr>", 'v', 'Visual Chat New split'),
        create_mapping('c<C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", 'v', 'Visual Chat New vsplit'),
        create_mapping('c<C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", 'v', 'Visual Chat New tabnew'),

        -- Prompt commands
        create_mapping('cr', '<cmd>GpRewrite<cr>', { 'n', 'i' }, 'Inline Rewrite'),
        create_mapping('ca', '<cmd>GpAppend<cr>', { 'n', 'i' }, 'Append (after)'),
        create_mapping('cb', '<cmd>GpPrepend<cr>', { 'n', 'i' }, 'Prepend (before)'),

        create_mapping('cr', ":<C-u>'<,'>GpRewrite<cr>", 'v', 'Visual Rewrite'),
        create_mapping('ca', ":<C-u>'<,'>GpAppend<cr>", 'v', 'Visual Append (after)'),
        create_mapping('cb', ":<C-u>'<,'>GpPrepend<cr>", 'v', 'Visual Prepend (before)'),
        create_mapping('ci', ":<C-u>'<,'>GpImplement<cr>", 'v', 'Implement selection'),

        create_mapping('cgp', '<cmd>GpPopup<cr>', { 'n', 'i' }, 'Popup'),
        create_mapping('cge', '<cmd>GpEnew<cr>', { 'n', 'i' }, 'GpEnew'),
        create_mapping('cgn', '<cmd>GpNew<cr>', { 'n', 'i' }, 'GpNew'),
        create_mapping('cgv', '<cmd>GpVnew<cr>', { 'n', 'i' }, 'GpVnew'),
        create_mapping('cgt', '<cmd>GpTabnew<cr>', { 'n', 'i' }, 'GpTabnew'),

        create_mapping('cgp', ":<C-u>'<,'>GpPopup<cr>", 'v', 'Visual Popup'),
        create_mapping('cge', ":<C-u>'<,'>GpEnew<cr>", 'v', 'Visual GpEnew'),
        create_mapping('cgn', ":<C-u>'<,'>GpNew<cr>", 'v', 'Visual GpNew'),
        create_mapping('cgv', ":<C-u>'<,'>GpVnew<cr>", 'v', 'Visual GpVnew'),
        create_mapping('cgt', ":<C-u>'<,'>GpTabnew<cr>", 'v', 'Visual GpTabnew'),

        create_mapping('cx', '<cmd>GpContext<cr>', { 'n', 'i' }, 'Toggle Context'),
        create_mapping('cx', ":<C-u>'<,'>GpContext<cr>", 'v', 'Visual Toggle Context'),

        create_mapping('cs', '<cmd>GpStop<cr>', { 'n', 'i', 'v', 'x' }, 'Stop'),
        create_mapping('cn', '<cmd>GpNextAgent<cr>', { 'n', 'i', 'v', 'x' }, 'Next Agent'),
      }
    end,
    config = function() require('gp').setup() end,
  },
}
