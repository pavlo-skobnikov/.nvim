return {
  {
    'tpope/vim-fugitive', -- Git wrapper
    dependencies = { 'nvim-telescope/telescope.nvim', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    config = function()
      U.register_keys {
        ['<leader>g'] = { ':Git<cr>', 'Git' },
        yog = { ':Git blame<cr>', 'Git blame' },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim', -- Git gutter & hunks
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter-textobjects', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    config = function()
      local function on_attach()
        local git_signs = package.loaded.gitsigns

        -- Navigation
        local function get_hunk_move_fn(mapping, action)
          return function()
            if vim.wo.diff then return mapping end

            vim.schedule(action)
            return '<Ignore>'
          end
        end

        U.register_keys {
          [']c'] = { get_hunk_move_fn(']c', git_signs.next_hunk), 'Next git change' },
          ['[c'] = { get_hunk_move_fn('[c', git_signs.prev_hunk), 'Previous git change' },
        }

        U.register_keys {
          -- Hunk actions
          ['<leader>h'] = {
            name = 'hunks',
            s = { git_signs.stage_hunk, 'Stage hunk' },
            r = { git_signs.reset_hunk, 'Reset hunk' },
            S = { git_signs.stage_buffer, 'Stage buffer' },
            u = { git_signs.undo_stage_hunk, 'Undo stage hunk' },
            R = { git_signs.reset_buffer, 'Reset buffer' },
            p = { git_signs.preview_hunk, 'Preview hunk' },
            b = { function() git_signs.blame_line { full = true } end, 'Blame line' },
            d = { git_signs.diffthis, 'Diff' },
            D = { function() git_signs.diffthis '~' end, 'Diff (cached)' },
          },
          -- Toggles
          yo = {
            d = { git_signs.toggle_deleted, 'Deleted hunks' },
            G = { git_signs.toggle_current_line_blame, 'Current line blame' },
          },
        }

        -- Hunk as a text object
        U.register_keys({ ih = { ':<C-U>Gitsigns select_hunk<cr>', 'inner hunk' } }, { mode = { 'o', 'x' } })
      end

      require('gitsigns').setup { on_attach = on_attach }
    end,
  },
}
