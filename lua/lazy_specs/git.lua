-- Git 'er done 💪
return {
  {
    'tpope/vim-fugitive', -- An outstanding git wrapper 🌯
    event = 'VeryLazy',
    config = function()
      SetG('n', 'gg', '<CMD>Git<CR>', { desc = 'Git' })
      SetG('n', 'gb', '<CMD>Git blame<CR>', { desc = 'Git blame' })
    end,
  },
  {
    'echasnovski/mini.diff', -- Git gutter and minimalistic diff view 👓
    version = '*',
    event = 'BufEnter',
    config = function()
      require('mini.diff').setup {
        view = { style = 'sign' },
        mappings = {
          -- Apply hunks inside a visual/operator region
          apply = Leader .. 'ghh',
          -- Reset hunks inside a visual/operator region
          reset = Leader .. 'ghr',
          -- Hunk range textobject to be used inside operator
          textobject = '',
          -- Go to hunk range in corresponding direction
          goto_first = '[C',
          goto_prev = '[c',
          goto_next = ']c',
          goto_last = ']C',
        },
        options = { wrap_goto = true },
      }

      SetG('n', 'gd', MiniDiff.toggle_overlay, { desc = 'Diff overlay' })
    end,
  },
}
