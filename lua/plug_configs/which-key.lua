local which_key = require 'which-key'

which_key.register {
  [P.leader] = {
    name = '+leader',
    d = {
      name = '+dap',
      b = { name = '+breakpoint' },
      f = { name = '+find' },
      r = { name = '+run' },
      s = { name = '+step' },
      w = { name = '+widgets' },
    },
    f = { name = '+find' },
    t = { name = '+toggle' },
  },
  s = { name = '+surround' },
  ys = { name = '+surround' },
  ds = { name = '+surround' },
  yo = { name = '+toggle' },
  gl = {
    name = '+lsp',
    c = { name = '+calls' },
    e = { name = '+errors' },
    s = { name = '+symbols' },
  },
  z = { name = '+fold' },
}

which_key.register({
  [P.leader] = {
    c = {
      name = '+chat-gpt',
      g = { name = '+generate' },
    },
    d = {
      name = '+dap',
      w = { name = '+widgets' },
    },
    g = {
      name = '+git',
      h = { name = '+hunk' },
    },
  },
}, { mode = { 'n', 'v' } })

which_key.register({
  g = { name = '+goto' },
  ['['] = { name = '+backwards' },
  [']'] = { name = '+forwards' },
}, { mode = { 'n', 'o', 'x' } })
