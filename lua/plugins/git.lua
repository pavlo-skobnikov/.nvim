return {
   {
      'tpope/vim-fugitive', -- Git wrapper
      dependencies = { 'nvim-telescope/telescope.nvim', 'folke/which-key.nvim' },
      event = 'VeryLazy',
      config = function()
         local telescope_builtin = PG.req_telescope_builtin()

         PG.reg_wk({
            name = 'git',
            b = { telescope_builtin.git_branches, 'Branches' },
            c = { telescope_builtin.git_commits, 'All commits' },
            d = { ':Gvdiff<cr>', 'Diff' },
            f = { ':Git fetch<SPAce>', 'Fetch' },
            g = { ':Git<cr>', 'Fugitive' },
            h = { ':0Gclog<cr>', 'File history' },
            l = { ':Git log<cr>', 'Changes log' },
            o = { ':Git checkout<space>', 'Checkout' },
            p = { ':Git push<space>', 'Push' },
            u = { ':Git pull<space>', 'Pull' },
            i = { telescope_builtin.git_status, 'Commit info (status)' },
            s = { telescope_builtin.git_stash, 'Stash' },
            ['?'] = { ':Git help<cr>', 'Help (?)' },
         }, { prefix = '<leader>g' })

         PG.reg_wk({ yog = { ':Git blame<cr>', 'git blame' } })
      end,
   },
   {
      'lewis6991/gitsigns.nvim', -- Git gutter & hunks
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-treesitter/nvim-treesitter-textobjects',
         'folke/which-key.nvim',
      },
      event = 'VeryLazy',
      config = function()
         local function on_attach()
            local git_signs = package.loaded.gitsigns

            -- Navigation between changes
            local function get_hunk_move_fn(mapping, action)
               return function()
                  if vim.wo.diff then return mapping end

                  vim.schedule(action)
                  return '<Ignore>'
               end
            end
            local repeat_move = PG.req_repeate_move()
            local next_hunk_fn, prev_hunk_fn = repeat_move.make_repeatable_move_pair(
               get_hunk_move_fn(']g', git_signs.next_hunk),
               get_hunk_move_fn('[g', git_signs.prev_hunk)
            )

            PG.reg_wk({
               [']g'] = { next_hunk_fn, 'Next git change' },
               ['[g'] = { prev_hunk_fn, 'Previous git change' },
            })

            -- Hunk actions
            PG.reg_wk({
               name = 'hunks',
               s = { git_signs.stage_hunk, 'Stage hunk' },
               u = { git_signs.undo_stage_hunk, 'Undo stage hunk' },
               h = { git_signs.reset_hunk, 'Reset hunk' },
               b = { git_signs.reset_buffer, 'Reset buffer' },
               p = { git_signs.preview_hunk, 'Preview hunk' },
               i = {
                  function() git_signs.blame_line({ full = true }) end,
                  'Git info for current line',
               },
               d = { git_signs.diffthis, 'Diff' },
               r = { function() git_signs.diffthis(vim.fn.input('Ref > ')) end, 'Diff against ref' },
            }, { prefix = '<leader>h' })

            -- Toggle removed hunks
            PG.reg_wk({ yod = { git_signs.toggle_deleted, 'Deleted hunks' } })

            -- Hunk as a text object
            PG.reg_wk(
               { ih = { ':<C-U>Gitsigns select_hunk<cr>', 'inner hunk' } },
               { mode = { 'o', 'x' } }
            )
         end

         require('gitsigns').setup({ on_attach = on_attach })
      end,
   },
}
