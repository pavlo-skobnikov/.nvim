-- Modes -> for reference
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
--   operator_pending_mode = 'o'

PG.reg_wk({
   ['<leader>H'] = {
      function()
         local word = vim.fn.expand('<cword>')

         vim.fn.matchadd('Search', word)
      end,
      'Highlight word',
   },
   ['<esc>'] = {
      function()
         vim.cmd(':noh')
         vim.cmd(':call clearmatches()')
         vim.lsp.buf.clear_references()
      end,
      'Remove all highlights on ESC',
   },
   ['<c-d>'] = { '<C-d>zz', 'Screen down and center' },
   ['<c-u>'] = { '<C-u>zz', 'Screen up and center' },
   ['d<space>'] = { 'f<space>diwi<space><esc>', 'Trim whitespace' },
   ['c<space>'] = { 'f<space>diwi<space>', 'Trim whitespace' },
   ['<leader>\\'] = {
      function()
         local spaces_count = tonumber(vim.fn.input('Spaces count > '))

         PG.set_tab_spaces(spaces_count)
      end,
      'Set Tab spaces',
   },
})

PG.reg_wk({
   g = { name = 'go-to' },
}, { mode = { 'v', 'x', 'o' } })
