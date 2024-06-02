-- Git 'er done 💪
return {
  {
    'tpope/vim-fugitive', -- An outstanding git wrapper 🌯
    event = 'VeryLazy',
    keys = {
      { Leader .. 'gg', '<CMD>Git<CR>', desc = 'Git' },
      { Leader .. 'gb', '<CMD>Git blame<CR>', desc = 'Git blame' },
    },
  },
  {
    'echasnovski/mini.diff', -- Git gutter and minimalistic diff view 👓
    version = '*',
    event = 'BufEnter',
    keys = {
      ---@diagnostic disable-next-line: missing-parameter
      { Leader .. 'gd', function() MiniDiff.toggle_overlay() end, desc = 'Diff overlay' },
    },
    opts = {
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
    },
    config = function(_, opts) require('mini.diff').setup(opts) end,
  },
}
