-- Remove all highlights
Set('n', '<esc>', function()
  vim.cmd ':noh'
  vim.cmd ':call clearmatches()'
  vim.lsp.buf.clear_references()
end)

-- Center screen on movement
Set('n', '<c-d>', '<C-d>zz')
Set('n', '<c-u>', '<C-u>zz')

-- Trim patches of whitespace to a single space
Set('n', 'd<space>', 'f<space>diwi<space><esc>')
Set('n', 'c<space>', 'f<space>diwi<space>')

-- Highlight word under cursor
Set('n', 'g*', function() vim.fn.matchadd('Search', vim.fn.expand '<cword>') end)

-- Actions without copying into the default register
Set('v', '<leader>D', '"_d', { desc = 'Delete without copying' })
Set('v', '<leader>P', '"_dP', { desc = 'Paste without copying' })
