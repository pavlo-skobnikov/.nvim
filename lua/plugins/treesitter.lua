local function getTsCfgs() return require 'nvim-treesitter.configs' end

return {
    {
        'nvim-treesitter/nvim-treesitter', -- Syntax highlighting
        build = ':TSUpdate',
        config = function()
            getTsCfgs().setup {
                ensure_installed = {
                    'c', -- Required for Treesitter to function parsers
                    'lua',
                    'vim',
                    'vimdoc',
                    'query',
                    'diff', -- Additional parsers
                    'gitattributes',
                    'gitcommit',
                    'gitignore',
                    'http',
                    'comment',
                    'markdown',
                    'json',
                    'dockerfile',
                    'yaml',
                    'terraform',
                    'hcl',
                    'sql',
                    'java',
                },

                sync_install = false, -- Install parsers synchronously
                auto_install = true, -- Auto-install missing parsers when entering buffer
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = false },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = 'gs',
                        node_incremental = ';',
                        node_decremental = ',',
                        scope_incremental = false,
                    },
                },
            }

            vim.cmd [[ " Treesitter folding
                set foldmethod=expr
                set foldexpr=nvim_treesitter#foldexpr()
                set nofoldenable " Disable folding at startup.
            ]]
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects', -- Additional Vim textobjects
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
        config = function()
            local function opts(query, desc) return { query = query, desc = desc } end

            getTsCfgs().setup {
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['ie'] = opts('@parameter.inner', 'inner argument element'),
                            ['ae'] = opts('@parameter.outer', 'around argument element'),
                            ['if'] = opts('@function.inner', 'inner function'),
                            ['af'] = opts('@function.outer', 'around function'),
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['>e'] = opts('@parameter.inner', 'Swap argument forwards'),
                            ['>f'] = opts('@function.outer', 'Swap function forwards'),
                        },
                        swap_previous = {
                            ['<e'] = opts('@parameter.inner', 'Swap argument backwards'),
                            ['<f'] = opts('@function.outer', 'Swap function backwards'),
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            [']a'] = opts('@parameter.inner', 'Next argument'),
                            [']f'] = opts('@function.outer', 'Next function'),
                        },
                        goto_previous_start = {
                            ['[a'] = opts('@parameter.inner', 'Previous argument'),
                            ['[f'] = opts('@function.outer', 'Previous function'),
                        },
                    },
                },
            }

            RegisterWK({ ['['] = 'backwards', [']'] = 'forwards' }, { mode = { 'o', 'x' } })

            local repeatMove = require 'nvim-treesitter.textobjects.repeatable_move'
            RegisterWK({
                [';'] = { repeatMove.repeat_last_move_next, 'Repeat last move forwards' },
                [','] = { repeatMove.repeat_last_move_previous, 'Repeat last move backwards' },
                ['f'] = { repeatMove.builtin_f, 'Search char forwards' },
                ['F'] = { repeatMove.builtin_F, 'Search char backwards' },
                ['t'] = { repeatMove.builtin_t, 'Search until char forwards' },
                ['T'] = { repeatMove.builtin_T, 'Search until char backwards' },
            }, { mode = { 'n', 'x', 'o' } })
        end,
    },
    {
        'nvim-treesitter/playground', -- Treesitter playground
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
        config = function()
            RegisterWK({
                p = {
                    name = 'ts-playground',
                    p = { ':TSPlaygroundToggle<CR>', 'Toggle playground' },
                    h = { ':TSHighlightCapturesUnderCursor<CR>', 'Highlight captures under cursor' },
                    n = { ':TSNodeUnderCursor<CR>', 'Highlight node under cursor' },
                },
            }, { prefix = '<LEADER>' })
        end,
    },
}
