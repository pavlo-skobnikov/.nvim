local telescope = require 'telescope'

telescope.setup {
  defaults = {
    dynamic_preview_title = true,
    path_display = { 'tail' },
    layout_strategy = 'vertical',
    layout_config = { vertical = { mirror = false } },
    pickers = { lsp_incoming_calls = { path_display = 'tail' } },
  },
  extensions = {
    fzf = {},
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'ui-select'

local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>t', '<cmd>Telescope<cr>', { desc = 'Telescope commands' })
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>s', builtin.live_grep, { desc = 'Search text' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy search in buffer' })
vim.keymap.set('n', '<leader>r', builtin.resume, { desc = 'Resume search' })
vim.keymap.set('n', '<leader>q', builtin.quickfix, { desc = 'Quickfix search' })
