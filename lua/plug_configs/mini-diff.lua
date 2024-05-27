require('mini.diff').setup {
  view = { style = 'sign' },
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = P.leader .. 'ghh',
    -- Reset hunks inside a visual/operator region
    reset = P.leader .. 'ghr',
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
