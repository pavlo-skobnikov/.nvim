return {
  {
    'github/copilot.vim', -- Wait a bit and get a mediocre completion
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }
    end,
  },
  {
    'robitx/gp.nvim', -- Proompt engineering 😤
    keys = function()
      local function get_mapping(lhs, rhs, mode, desc)
        return {
          lhs,
          rhs,
          mode = mode,
          noremap = true,
          silent = true,
          nowait = true,
          desc = 'GPT: ' .. desc,
        }
      end

      return {
        -- Chat commands
        get_mapping('<C-g>c', '<cmd>GpChatNew<cr>', { 'n', 'i' }, 'new chat'),
        get_mapping('<C-g>t', '<cmd>GpChatToggle<cr>', { 'n', 'i' }, 'toggle chat'),
        get_mapping('<C-g>f', '<cmd>GpChatFinder<cr>', { 'n', 'i' }, 'chat finder'),

        get_mapping('<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", 'v', 'visual chat new'),
        get_mapping('<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", 'v', 'visual chat paste'),
        get_mapping('<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", 'v', 'visual toggle chat'),

        get_mapping('<C-g><C-x>', '<cmd>GpChatNew split<cr>', { 'n', 'i' }, 'new chat split'),
        get_mapping('<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', { 'n', 'i' }, 'new chat vsplit'),
        get_mapping('<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', { 'n', 'i' }, 'new chat tabnew'),

        get_mapping('<C-g><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", 'v', 'visual chat new split'),
        get_mapping('<C-g><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", 'v', 'visual chat new vsplit'),
        get_mapping('<C-g><C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", 'v', 'visual chat new tabnew'),

        -- Prompt commands
        get_mapping('<C-g>r', '<cmd>GpRewrite<cr>', { 'n', 'i' }, 'inline rewrite'),
        get_mapping('<C-g>a', '<cmd>GpAppend<cr>', { 'n', 'i' }, 'append (after)'),
        get_mapping('<C-g>b', '<cmd>GpPrepend<cr>', { 'n', 'i' }, 'prepend (before)'),

        get_mapping('<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", 'v', 'visual rewrite'),
        get_mapping('<C-g>a', ":<C-u>'<,'>GpAppend<cr>", 'v', 'visual append (after)'),
        get_mapping('<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", 'v', 'visual prepend (before)'),
        get_mapping('<C-g>i', ":<C-u>'<,'>GpImplement<cr>", 'v', 'implement selection'),

        get_mapping('<C-g>gp', '<cmd>GpPopup<cr>', { 'n', 'i' }, 'popup'),
        get_mapping('<C-g>ge', '<cmd>GpEnew<cr>', { 'n', 'i' }, 'gpenew'),
        get_mapping('<C-g>gn', '<cmd>GpNew<cr>', { 'n', 'i' }, 'gpnew'),
        get_mapping('<C-g>gv', '<cmd>GpVnew<cr>', { 'n', 'i' }, 'gpvnew'),
        get_mapping('<C-g>gt', '<cmd>GpTabnew<cr>', { 'n', 'i' }, 'gptabnew'),

        get_mapping('<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", 'v', 'visual popup'),
        get_mapping('<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", 'v', 'visual gpenew'),
        get_mapping('<C-g>gn', ":<C-u>'<,'>GpNew<cr>", 'v', 'visual gpnew'),
        get_mapping('<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", 'v', 'visual gpvnew'),
        get_mapping('<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", 'v', 'visual gptabnew'),

        get_mapping('<C-g>x', '<cmd>GpContext<cr>', { 'n', 'i' }, 'toggle context'),
        get_mapping('<C-g>x', ":<C-u>'<,'>GpContext<cr>", 'v', 'visual toggle context'),

        get_mapping('<C-g>s', '<cmd>GpStop<cr>', { 'n', 'i', 'v', 'x' }, 'stop'),
        get_mapping('<C-g>n', '<cmd>GpNextAgent<cr>', { 'n', 'i', 'v', 'x' }, 'next agent'),
      }
    end,
    config = function() require('gp').setup() end,
  },
}
