return {
  {
    'tpope/vim-fugitive', -- Git wrapper
    cmd = { 'G', 'Git' },
    keys = {
      { '<leader>g', ':Git<cr>', desc = 'Git' },
      { 'yog', ':Git blame<cr>', desc = 'Git blame' },
    },
  },
  {
    'echasnovski/mini.diff',
    version = false,
    event = 'BufEnter',
    keys = {
      { 'yoD', '<cmd>lua MiniDiff.toggle_overlay()<cr>', desc = 'Diff overlay' },
    },
    opts = {
      view = {
        style = 'sign',
      },
      mappings = {
        -- Apply hunks inside a visual/operator region
        apply = 'gh',
        -- Reset hunks inside a visual/operator region
        reset = 'gH',
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
