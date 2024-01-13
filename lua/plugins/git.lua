return {
    {
        'tpope/vim-fugitive', -- Git wrapper
        dependencies = { 'nvim-telescope/telescope.nvim', 'folke/which-key.nvim' },
        config = function()
            local tb = require 'telescope.builtin'

            RegisterWK({
                name = 'git',
                b = { tb.git_branches, 'Branches' },
                c = { tb.git_commits, 'All commits' },
                d = { ':Gvdiff<CR>', 'Diff' },
                f = { ':Git fetch<SPACE>', 'Fetch' },
                g = { ':Git<CR>', 'Fugitive' },
                h = { ':0Gclog<CR>', 'File history' },
                l = { ':Git log<CR>', 'Changes log' },
                o = { ':Git checkout<SPACE>', 'Checkout' },
                p = { ':Git push<SPACE>', 'Push' },
                u = { ':Git pull<SPACE>', 'Pull' },
                i = { tb.git_status, 'Commit info (status)' },
                s = { tb.git_stash, 'Stash' },
                ['?'] = { ':Git help<CR>', 'Help (?)' },
            }, { prefix = '<LEADER>g' })

            RegisterWK { yog = { ':Git blame<CR>', 'git blame' } }
        end,
    },
    {
        'lewis6991/gitsigns.nvim', -- Git gutter && hunks
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/which-key.nvim',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            local function onAttach()
                local gs = package.loaded.gitsigns

                -- Navigation between hunks
                local function getHunkMoveFunc(mapping, action)
                    return function()
                        if vim.wo.diff then return mapping end

                        vim.schedule(action)
                        return '<Ignore>'
                    end
                end
                local repeatMove = require 'nvim-treesitter.textobjects.repeatable_move'
                local nextHunkFunc, prevHunkFunc = repeatMove.make_repeatable_move_pair(
                    getHunkMoveFunc(']g', gs.next_hunk),
                    getHunkMoveFunc('[g', gs.prev_hunk)
                )

                RegisterWK {
                    [']g'] = { nextHunkFunc, 'Next git change' },
                    ['[g'] = { prevHunkFunc, 'Previous git change' },
                }

                -- Hunk actions
                RegisterWK({
                    name = 'hunks',
                    s = { gs.stage_hunk, 'Stage hunk' },
                    u = { gs.undo_stage_hunk, 'Undo stage hunk' },
                    h = { gs.reset_hunk, 'Reset hunk' },
                    b = { gs.reset_buffer, 'Reset buffer' },
                    p = { gs.preview_hunk, 'Preview hunk' },
                    i = {
                        function() gs.blame_line { full = true } end,
                        'Git info for current line',
                    },
                    d = { gs.diffthis, 'Diff' },
                    r = { function() gs.diffthis(vim.fn.input 'Ref > ') end, 'Diff against ref' },
                }, { prefix = '<LEADER>h' })

                -- Toggle removed hunks
                RegisterWK { yod = { gs.toggle_deleted, 'Deleted hunks' } }

                -- Hunk as a text object
                RegisterWK(
                    { h = { ':<C-U>Gitsigns select_hunk<CR>', 'inner hunk' } },
                    { prefix = 'i', mode = { 'o', 'x' } }
                )
            end

            require('gitsigns').setup { on_attach = onAttach }
        end,
    },
}
