return {
  'folke/which-key.nvim', -- Mapping keys like it's nothing
  event = 'VeryLazy',
  config = function()
    local which_key = require 'which-key'

    which_key.register {
      cs = { name = 'surround' },
      ys = { name = 'surround' },
      ds = { name = 'surround' },
      yo = { name = 'toggle' },
      gl = 'LSP',
      ['<leader>'] = {
        d = {
          name = 'dap',
          b = { name = 'breakpoint' },
          f = { name = 'find' },
          r = { name = 'run' },
          s = { name = 'step' },
          w = { name = 'widgets' },
        },
        f = { name = 'find' },
        h = { name = 'hunks' },
        r = 'refactor',
        m = { name = 'major' },
      },
      ['<localleader>'] = {
        c = { name = 'connect' },
        e = { name = 'evaluate', c = 'comment' },
        g = { name = 'get' },
        l = { name = 'log' },
        r = { name = 'run' },
        s = { name = 'sessions' },
        v = { name = 'variables' },
        t = { name = 'test' },
      },
    }

    which_key.register({
      ['['] = { name = 'backwards' },
      [']'] = { name = 'forwards' },
    }, { mode = { 'o', 'x' } })

    which_key.register({
      ['<c-g>'] = {
        g = { name = 'generate into' },
        w = { name = 'whisper' },
      },
    }, { mode = { 'n', 'v' } })
  end,
}
