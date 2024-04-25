return {
  {
    'tpope/vim-fugitive', -- Git wrapper
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<leader>g', ':Git<cr>', { desc = 'Git' })
      vim.keymap.set('n', 'yog', ':Git blame<cr>', { desc = 'Git blame' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim', -- Git gutter & hunks
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter-textobjects' },
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

        vim.keymap.set('n', ']c', get_hunk_move_fn(']c', git_signs.next_hunk), { desc = 'Next git change' })
        vim.keymap.set('n', '[c', get_hunk_move_fn('[c', git_signs.prev_hunk), { desc = 'Previous git change' })

        -- Hunk actions
        vim.keymap.set('n', '<leader>hs', git_signs.stage_hunk, { desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>hr', git_signs.reset_hunk, { desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>hS', git_signs.stage_buffer, { desc = 'Stage buffer' })
        vim.keymap.set('n', '<leader>hu', git_signs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        vim.keymap.set('n', '<leader>hR', git_signs.reset_buffer, { desc = 'Reset buffer' })
        vim.keymap.set('n', '<leader>hp', git_signs.preview_hunk, { desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>hb', function() git_signs.blame_line { full = true } end, { desc = 'Blame line' })
        vim.keymap.set('n', '<leader>hd', git_signs.diffthis, { desc = 'Diff' })
        vim.keymap.set('n', '<leader>hD', function() git_signs.diffthis '~' end, { desc = 'Diff (cached)' })

        -- Toggles
        vim.keymap.set('n', 'yod', git_signs.toggle_deleted, { desc = 'Deleted hunks' })
        vim.keymap.set('n', 'yoG', git_signs.toggle_current_line_blame, { desc = 'Current line blame' })

        -- Hunk as a text object
        vim.keymap.set('o', 'ih', ':<C-U>Gitsigns select_hunk<cr>', { desc = 'inner hunk' })
      end

      require('gitsigns').setup { on_attach = on_attach }
    end,
  },
}
