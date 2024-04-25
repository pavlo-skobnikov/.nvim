return {
  'robitx/gp.nvim',
  event = 'VeryLazy',
  config = function()
    require('gp').setup()

    local function createOptions(desc)
      return { noremap = true, silent = true, nowait = true, desc = 'GPT prompt ' .. desc }
    end

    -- Chat commands
    vim.keymap.set({ 'n', 'i' }, '<C-g>c', '<cmd>GpChatNew<cr>', createOptions 'New chat')
    vim.keymap.set({ 'n', 'i' }, '<C-g>t', '<cmd>GpChatToggle<cr>', createOptions 'Toggle chat')
    vim.keymap.set({ 'n', 'i' }, '<C-g>f', '<cmd>GpChatFinder<cr>', createOptions 'Chat finder')

    vim.keymap.set('v', '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", createOptions 'Visual chat new')
    vim.keymap.set('v', '<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", createOptions 'Visual chat paste')
    vim.keymap.set('v', '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", createOptions 'Visual toggle chat')

    vim.keymap.set({ 'n', 'i' }, '<C-g><C-x>', '<cmd>GpChatNew split<cr>', createOptions 'New chat split')
    vim.keymap.set({ 'n', 'i' }, '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', createOptions 'New chat vsplit')
    vim.keymap.set({ 'n', 'i' }, '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', createOptions 'New chat tabnew')

    vim.keymap.set('v', '<C-g><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", createOptions 'Visual chat new split')
    vim.keymap.set('v', '<C-g><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", createOptions 'Visual chat new vsplit')
    vim.keymap.set('v', '<C-g><C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", createOptions 'Visual chat new tabnew')

    -- Prompt commands
    vim.keymap.set({ 'n', 'i' }, '<C-g>r', '<cmd>GpRewrite<cr>', createOptions 'Inline rewrite')
    vim.keymap.set({ 'n', 'i' }, '<C-g>a', '<cmd>GpAppend<cr>', createOptions 'Append (after)')
    vim.keymap.set({ 'n', 'i' }, '<C-g>b', '<cmd>GpPrepend<cr>', createOptions 'Prepend (before)')

    vim.keymap.set('v', '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", createOptions 'Visual rewrite')
    vim.keymap.set('v', '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", createOptions 'Visual append (after)')
    vim.keymap.set('v', '<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", createOptions 'Visual prepend (before)')
    vim.keymap.set('v', '<C-g>i', ":<C-u>'<,'>GpImplement<cr>", createOptions 'Implement selection')

    vim.keymap.set({ 'n', 'i' }, '<C-g>gp', '<cmd>GpPopup<cr>', createOptions 'Popup')
    vim.keymap.set({ 'n', 'i' }, '<C-g>ge', '<cmd>GpEnew<cr>', createOptions 'GpEnew')
    vim.keymap.set({ 'n', 'i' }, '<C-g>gn', '<cmd>GpNew<cr>', createOptions 'GpNew')
    vim.keymap.set({ 'n', 'i' }, '<C-g>gv', '<cmd>GpVnew<cr>', createOptions 'GpVnew')
    vim.keymap.set({ 'n', 'i' }, '<C-g>gt', '<cmd>GpTabnew<cr>', createOptions 'GpTabnew')

    vim.keymap.set('v', '<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", createOptions 'Visual popup')
    vim.keymap.set('v', '<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", createOptions 'Visual GpEnew')
    vim.keymap.set('v', '<C-g>gn', ":<C-u>'<,'>GpNew<cr>", createOptions 'Visual GpNew')
    vim.keymap.set('v', '<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", createOptions 'Visual GpVnew')
    vim.keymap.set('v', '<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", createOptions 'Visual GpTabnew')

    vim.keymap.set({ 'n', 'i' }, '<C-g>x', '<cmd>GpContext<cr>', createOptions 'Toggle context')
    vim.keymap.set('v', '<C-g>x', ":<C-u>'<,'>GpContext<cr>", createOptions 'Visual toggle context')

    vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>s', '<cmd>GpStop<cr>', createOptions 'Stop')
    vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>n', '<cmd>GpNextAgent<cr>', createOptions 'Next agent')

    -- Optional Whisper commands with prefix <C-g>w
    vim.keymap.set({ 'n', 'i' }, '<C-g>ww', '<cmd>GpWhisper<cr>', createOptions 'Whisper')
    vim.keymap.set('v', '<C-g>ww', ":<C-u>'<,'>GpWhisper<cr>", createOptions 'Visual whisper')

    vim.keymap.set({ 'n', 'i' }, '<C-g>wr', '<cmd>GpWhisperRewrite<cr>', createOptions 'Whisper inline rewrite')
    vim.keymap.set({ 'n', 'i' }, '<C-g>wa', '<cmd>GpWhisperAppend<cr>', createOptions 'Whisper append (after)')
    vim.keymap.set({ 'n', 'i' }, '<C-g>wb', '<cmd>GpWhisperPrepend<cr>', createOptions 'Whisper prepend (before) ')

    vim.keymap.set('v', '<C-g>wr', ":<C-u>'<,'>GpWhisperRewrite<cr>", createOptions 'Visual whisper rewrite')
    vim.keymap.set('v', '<C-g>wa', ":<C-u>'<,'>GpWhisperAppend<cr>", createOptions 'Visual whisper append (after)')
    vim.keymap.set('v', '<C-g>wb', ":<C-u>'<,'>GpWhisperPrepend<cr>", createOptions 'Visual whisper prepend (before)')

    vim.keymap.set({ 'n', 'i' }, '<C-g>wp', '<cmd>GpWhisperPopup<cr>', createOptions 'Whisper popup')
    vim.keymap.set({ 'n', 'i' }, '<C-g>we', '<cmd>GpWhisperEnew<cr>', createOptions 'Whisper enew')
    vim.keymap.set({ 'n', 'i' }, '<C-g>wn', '<cmd>GpWhisperNew<cr>', createOptions 'Whisper new')
    vim.keymap.set({ 'n', 'i' }, '<C-g>wv', '<cmd>GpWhisperVnew<cr>', createOptions 'Whisper Vnew')
    vim.keymap.set({ 'n', 'i' }, '<C-g>wt', '<cmd>GpWhisperTabnew<cr>', createOptions 'Whisper tabnew')

    vim.keymap.set('v', '<C-g>wp', ":<C-u>'<,'>GpWhisperPopup<cr>", createOptions 'Visual whisper popup')
    vim.keymap.set('v', '<C-g>we', ":<C-u>'<,'>GpWhisperEnew<cr>", createOptions 'Visual whisper enew')
    vim.keymap.set('v', '<C-g>wn', ":<C-u>'<,'>GpWhisperNew<cr>", createOptions 'Visual whisper new')
    vim.keymap.set('v', '<C-g>wv', ":<C-u>'<,'>GpWhisperVnew<cr>", createOptions 'Visual whisper vnew')
    vim.keymap.set('v', '<C-g>wt', ":<C-u>'<,'>GpWhisperTabnew<cr>", createOptions 'Visual whisper tabnew')
  end,
}
