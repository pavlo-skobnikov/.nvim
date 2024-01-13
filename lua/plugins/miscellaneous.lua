return {
    {
        'julienvincent/nvim-paredit', -- Paredit for Neovim
        lazy = true,
        ft = { 'clojure', 'fennel', 'lisp', 'scheme' },
        config = function()
            local paredit = require 'nvim-paredit'

            paredit.setup {
                use_default_keys = true,
                filetypes = { 'clojure' },
                cursor_behaviour = 'auto', -- remain, follow, auto
                indent = {
                    enabled = true,
                    indentor = require('nvim-paredit.indentation.native').indentor,
                },
                keys = {
                    -- Main s-expression editing bindings
                    ['dsf'] = { paredit.unwrap.unwrap_form_under_cursor, 'Splice form' },

                    ['<LOCALLEADER>o'] = { paredit.api.raise_form, 'Raise form' },
                    ['<LOCALLEADER>O'] = { paredit.api.raise_element, 'Raise element' },

                    ['<LOCALLEADER>i'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('', ''),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Insert in form',
                    },
                    ['<LOCALLEADER>I'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('', ''),
                                { placement = 'left_edge', mode = 'insert' }
                            )
                        end,
                        'Insert in form',
                    },
                    ['<LOCALLEADER>a'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('', ''),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Append in form',
                    },
                    ['<LOCALLEADER>A'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('', ''),
                                { placement = 'right_edge', mode = 'insert' }
                            )
                        end,
                        'Append in form',
                    },

                    ['>)'] = { paredit.api.slurp_forwards, 'Slurp forwards' },
                    ['<('] = { paredit.api.slurp_backwards, 'Slurp backwards' },
                    ['>('] = { paredit.api.barf_backwards, 'Barf backwards' },
                    ['<)'] = { paredit.api.barf_forwards, 'Barf forwards' },

                    ['>e'] = { paredit.api.drag_element_forwards, 'Drag element right' },
                    ['<e'] = { paredit.api.drag_element_backwards, 'Drag element left' },
                    ['>f'] = { paredit.api.drag_form_forwards, 'Drag form right' },
                    ['<f'] = { paredit.api.drag_form_backwards, 'Drag form left' },

                    ['cse('] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('( ', ')'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap (element) & insert head',
                    },
                    ['cse)'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('(', ')'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap (element) & insert tail',
                    },
                    ['cse['] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('[ ', ']'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap [element] & insert head',
                    },
                    ['cse]'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('[', ']'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap [element] & insert tail',
                    },
                    ['cse{'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('{ ', '}'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap {element} & insert head',
                    },
                    ['cse}'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_element_under_cursor('{', '}'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap {element} & insert tail',
                    },

                    ['csf('] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('( ', ')'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap (element) & insert head',
                    },
                    ['csf)'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('(', ')'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap (element) & insert tail',
                    },
                    ['csf['] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('[ ', ']'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap [element] & insert head',
                    },
                    ['csf]'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('[', ']'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap [element] & insert tail',
                    },
                    ['csf{'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('{ ', '}'),
                                { placement = 'inner_start', mode = 'insert' }
                            )
                        end,
                        'Wrap {element} & insert head',
                    },
                    ['csf}'] = {
                        function()
                            paredit.cursor.place_cursor(
                                paredit.wrap.wrap_enclosing_form_under_cursor('{', '}'),
                                { placement = 'inner_end', mode = 'insert' }
                            )
                        end,
                        'Wrap {element} & insert tail',
                    },

                    -- Movement bindings
                    ['E'] = {
                        paredit.api.move_to_next_element_tail,
                        'Jump to next element tail',
                        mode = { 'n', 'x', 'o', 'v' },
                    },
                    ['W'] = {
                        paredit.api.move_to_next_element_head,
                        'Jump to next element head',
                        mode = { 'n', 'x', 'o', 'v' },
                    },

                    ['B'] = {
                        paredit.api.move_to_prev_element_head,
                        'Jump to previous element head',
                        mode = { 'n', 'x', 'o', 'v' },
                    },
                    ['gE'] = {
                        paredit.api.move_to_prev_element_tail,
                        'Jump to previous element tail',
                        mode = { 'n', 'x', 'o', 'v' },
                    },

                    ['('] = {
                        paredit.api.move_to_parent_form_start,
                        "Jump to parent form's head",
                        mode = { 'n', 'x', 'v' },
                    },
                    [')'] = {
                        paredit.api.move_to_parent_form_end,
                        "Jump to parent form's tail",
                        mode = { 'n', 'x', 'v' },
                    },

                    -- Textobject bindings
                    ['af'] = {
                        paredit.api.select_around_form,
                        'around form',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                    ['if'] = {
                        paredit.api.select_in_form,
                        'inner form',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                    ['aF'] = {
                        paredit.api.select_around_top_level_form,
                        'around top-level form',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                    ['iF'] = {
                        paredit.api.select_in_top_level_form,
                        'inner top-level form',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                    ['ae'] = {
                        paredit.api.select_element,
                        'an element',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                    ['ie'] = {
                        paredit.api.select_element,
                        'inner element',
                        repeatable = false,
                        mode = { 'o', 'v' },
                    },
                },
            }

            RegisterWK { cse = 'wrap-element', csf = 'wrap-form' }
        end,
    },
    {
        'tpope/vim-surround', -- Cool surround actions for `cs`, `cS`, and `ds` mappings
        config = function()
            RegisterWK {
                cs = { name = 'surround' },
                ys = { name = 'surround' },
                ds = { name = 'surround' },
            }
        end,
    },
    { 'tpope/vim-repeat' }, -- Repeat plugin maps
    { 'windwp/nvim-autopairs', config = true }, -- Auto-create pair characters when typing
    { 'numToStr/Comment.nvim', config = true }, -- Selection- && motion-based commenting
    {
        'mbbill/undotree', -- A detailed undo history for files
        dependencies = 'folke/which-key.nvim',
        config = function()
            RegisterWK(
                { u = { ':UndotreeToggle<CR>', 'Toggle Undotree' } },
                { prefix = '<LEADER>' }
            )
        end,
    },
    {
        'Tummetott/unimpaired.nvim', -- Useful && comfy mappings for basic Vim commands
        config = function()
            local function desc(description) return { description = description } end

            require('unimpaired').setup {
                default_keymaps = true,
                keymaps = {
                    previous = false,
                    next = false,
                    first = false,
                    last = false,
                    bprevious = desc 'buffer',
                    bnext = desc 'buffer',
                    bfirst = desc 'First buffer',
                    blast = desc 'Last buffer',
                    lprevious = desc 'loclist',
                    lnext = desc 'loclist',
                    lfirst = desc 'First loclist',
                    llast = desc 'Last loclist',
                    lpfile = desc 'loclist file',
                    lnfile = desc 'loclist file',
                    cprevious = desc 'qflist',
                    cnext = desc 'qflist',
                    cfirst = desc 'First qflist',
                    clast = desc 'Last qflist',
                    cpfile = desc 'qflist file',
                    cnfile = desc 'qflist file',
                    tprevious = desc 'Matching tag',
                    tnext = desc 'Matching tag',
                    tfirst = desc 'First matching tag',
                    tlast = desc 'Last matching tag',
                    ptprevious = desc ':tprevious in preview',
                    ptnext = desc ':tnext in preview',
                    previous_file = desc 'Directory file',
                    next_file = desc 'Directory file',
                    blank_above = desc 'Add blank line(s) above',
                    blank_below = desc 'Add blank line(s) below',
                    exchange_above = desc 'Exchange above line(s)',
                    exchange_below = desc 'Exchange below line(s)',
                    exchange_section_above = desc 'Move section up',
                    exchange_section_below = desc 'Move section down',
                    enable_cursorline = false,
                    disable_cursorline = false,
                    toggle_cursorline = desc 'cursorline',
                    enable_diff = false,
                    disable_diff = false,
                    toggle_diff = desc 'diffthis',
                    enable_hlsearch = false,
                    disable_hlsearch = false,
                    toggle_hlsearch = desc 'hlsearch',
                    enable_ignorecase = false,
                    disable_ignorecase = false,
                    toggle_ignorecase = desc 'ignorecase',
                    enable_list = false,
                    disable_list = false,
                    toggle_list = desc 'listchars',
                    enable_number = false,
                    disable_number = false,
                    toggle_number = desc 'Line numbers',
                    enable_relativenumber = false,
                    disable_relativenumber = false,
                    toggle_relativenumber = desc 'Relative numbers',
                    enable_spell = false,
                    disable_spell = false,
                    toggle_spell = desc 'Spell check',
                    enable_background = false,
                    disable_background = false,
                    toggle_background = desc 'Background',
                    enable_colorcolumn = false,
                    disable_colorcolumn = false,
                    toggle_colorcolumn = desc 'colorcolumn',
                    enable_cursorcolumn = false,
                    disable_cursorcolumn = false,
                    toggle_cursorcolumn = desc 'cursorcolumn',
                    enable_virtualedit = false,
                    disable_virtualedit = false,
                    toggle_virtualedit = desc 'virtualedit',
                    enable_wrap = false,
                    disable_wrap = false,
                    toggle_wrap = desc 'Line wrapping',
                    enable_cursorcross = false,
                    disable_cursorcross = false,
                    toggle_cursorcross = desc 'cursorcross (x)',
                },
            }

            RegisterWK { yo = 'toggle' }
        end,
    },
    {
        'stevearc/oil.nvim', -- Vim buffer-like editing for the file system
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('oil').setup { view_options = { show_hidden = true } }

            RegisterWK { ['-'] = { '<CMD>Oil<CR>', 'Open parent directory' } }
        end,
    },
    {
        'christoomey/vim-tmux-navigator', -- Seamlessly navigate Vim and Tmux splits
        config = function()
            vim.cmd [[
                    let g:tmux_navigator_no_mappings = 1
                    let g:tmux_navigator_save_on_switch = 2
                ]]

            RegisterWK({
                ['<C-h>'] = { ':<C-U>TmuxNavigateLeft<cr>', 'Move a split left' },
                ['<C-j>'] = { ':<C-U>TmuxNavigateDown<cr>', 'Move a split down' },
                ['<C-k>'] = { ':<C-U>TmuxNavigateUp<cr>', 'Move a split up' },
                ['<C-l>'] = { ':<C-U>TmuxNavigateRight<cr>', 'Move a split right' },
                ['<C-\\>'] = { ':<C-U>TmuxNavigatePrevious<cr>', 'Move to the previous split' },
            }, { mode = { 'n', 'x', 'o' } })
        end,
    },
    {
        'catppuccin/nvim', -- Colorscheme, duh
        config = function()
            require('catppuccin').setup { flavour = 'frappe' }

            vim.cmd [[ colorscheme catppuccin ]]
        end,
    },
    { 'folke/which-key.nvim' }, -- _The_ shortcut popup menu plugin
}
