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

-- Basic actions
Set('n', '<M-x>', builtin.commands, { desc = 'Search and execute commands' })
Set('n', '<M-/>', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy search in buffer' })

SetG('n', 'fa', '<cmd>Telescope<cr>', { desc = 'Telescope actions' })
SetG('n', 'fr', builtin.resume, { desc = 'Resume previous search' })
SetG('n', 'f<C-h>', builtin.help_tags, { desc = 'Help tags' })

SetG('n', 'ff', builtin.find_files, { desc = 'Files' })
SetG('n', 'fh', builtin.oldfiles, { desc = 'File history' })

SetG('n', 'fg', builtin.live_grep, { desc = 'grep' })

SetG('n', 'fq', builtin.quickfix, { desc = 'Quickfix' })
SetG('n', 'fQ', builtin.quickfixhistory, { desc = 'Quickfix history' })
SetG('n', 'fR', builtin.registers, { desc = 'Registers' })

-- Git
SetG('n', 'gc', builtin.git_commits, { desc = 'Commits' })
SetG('n', 'gC', builtin.git_bcommits, { desc = 'Buffer commits' })
SetG('n', 'gB', builtin.git_branches, { desc = 'Branches' })
SetG('n', 'gs', builtin.git_status, { desc = 'Status' })
SetG('n', 'gS', builtin.git_stash, { desc = 'Stash' })
