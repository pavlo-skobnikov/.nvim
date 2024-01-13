-- Modes -> for reference
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
--   operator_pending_mode = 'o'

RegisterWK {
    ['<LEADER>H'] = {
        function()
            local word = vim.fn.expand '<cword>'

            vim.fn.matchadd('Search', word)
        end,
        'Highlight word',
    },
    ['<ESC>'] = {
        function()
            vim.cmd ':noh'
            vim.cmd ':call clearmatches()'
            vim.lsp.buf.clear_references()
        end,
        'Remove all highlights on ESC',
    },
    ['<C-d>'] = { '<C-d>zz', 'Screen down and center' },
    ['<C-u>'] = { '<C-u>zz', 'Screen up and center' },
    ['d<SPACE>'] = { 'f<SPACE>diwi<SPACE><ESC>', 'Trim whitespace' },
    ['c<SPACE>'] = { 'f<SPACE>diwi<SPACE>', 'Trim whitespace' },
}

RegisterWK({
    g = { name = 'go-to' },
}, { mode = { 'v', 'x', 'o' } })
