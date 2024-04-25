-- Remove all highlights
vim.keymap.set('n', '<esc>', function()
  vim.cmd ':noh'
  vim.cmd ':call clearmatches()'
  vim.lsp.buf.clear_references()
end)

-- Center screen on movement
vim.keymap.set('n', '<c-d>', '<C-d>zz')
vim.keymap.set('n', '<c-u>', '<C-u>zz')

-- Trim patches of whitespace to a single space
vim.keymap.set('n', 'd<space>', 'f<space>diwi<space><esc>')
vim.keymap.set('n', 'c<space>', 'f<space>diwi<space>')

-- Highlight word under cursor
vim.keymap.set('n', 'g*', function()
  vim.fn.matchadd('Search', vim.fn.expand '<cword>')
end)

-- Actions without copying into the default register
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete without copying' })
vim.keymap.set('v', '<leader>p', '"_dP', { desc = 'Paste without copying' })
