-- Git gutter and minimalistic diff view 👓
return {
  'echasnovski/mini.diff',
  version = '*',
  event = 'BufEnter',
  keys = {
    ---@diagnostic disable-next-line: missing-parameter
    { '<LEADER>gd', function() MiniDiff.toggle_overlay() end, desc = 'Diff overlay' },
  },
  opts = {
    view = { style = 'sign' },
    mappings = {
      -- Stage hunks inside a visual/operator region.
      apply = 'ghs',
      -- Reset hunks inside a visual/operator region.
      reset = 'ghr',
      -- Hunk range textobject to be used inside operator.
      textobject = '',
      -- Go to hunk range in corresponding direction.
      goto_first = '[C',
      goto_prev = '[c',
      goto_next = ']c',
      goto_last = ']C',
    },
    options = { wrap_goto = true },
  },
  config = function(_, opts) require('mini.diff').setup(opts) end,
}
