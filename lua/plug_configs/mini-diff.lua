require('mini.diff').setup {
  view = { style = 'sign' },
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
}

vim.keymap.set('n', 'yoD', MiniDiff.toggle_overlay, { desc = 'Diff overlay' })
