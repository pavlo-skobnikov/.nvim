return {
  {
    'tpope/vim-fugitive', -- Git wrapper
    dependencies = { 'nvim-telescope/telescope.nvim', 'folke/which-key.nvim' },
    event = 'VeryLazy',
    config = function()
      local telescope_builtin = require 'telescope.builtin'

      UTIL.register_keys({
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

      UTIL.register_keys { yog = { ':Git blame<cr>', 'git blame' } }
    end,
  },
  {
    'lewis6991/gitsigns.nvim', -- Git gutter & hunks
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter-textobjects', 'folke/which-key.nvim' },
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

        UTIL.register_keys {
          [']g'] = { get_hunk_move_fn(']g', git_signs.next_hunk), 'Next git change' },
          ['[g'] = { get_hunk_move_fn('[g', git_signs.prev_hunk), 'Previous git change' },
        }

        -- Hunk actions
        UTIL.register_keys({
          name = 'hunks',
          s = { git_signs.stage_hunk, 'Stage hunk' },
          u = { git_signs.undo_stage_hunk, 'Undo stage hunk' },
          h = { git_signs.reset_hunk, 'Reset hunk' },
          b = { git_signs.reset_buffer, 'Reset buffer' },
          p = { git_signs.preview_hunk, 'Preview hunk' },
          i = { function() git_signs.blame_line { full = true } end, 'Git info for current line' },
          d = { git_signs.diffthis, 'Diff' },
          r = { function() git_signs.diffthis(vim.fn.input 'Ref > ') end, 'Diff against ref' },
        }, { prefix = '<leader>h' })

        -- Toggle removed hunks
        UTIL.register_keys { yod = { git_signs.toggle_deleted, 'Deleted hunks' } }

        -- Hunk as a text object
        UTIL.register_keys({ ih = { ':<C-U>Gitsigns select_hunk<cr>', 'inner hunk' } }, { mode = { 'o', 'x' } })
      end

      require('gitsigns').setup { on_attach = on_attach }
    end,
  },
}
