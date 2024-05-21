local which_key = require 'which-key'

which_key.register {
  c = {
    r = {
      name = '+refactor',
      m = { name = '+major' },
    },
    d = {
      name = '+dap',
      b = { name = '+breakpoint' },
      f = { name = '+find' },
      r = { name = '+run' },
      s = { name = '+step' },
      w = { name = '+widgets' },
    },
    g = { name = '+goto' },
    s = { name = '+surround' },
  },
  ys = { name = '+surround' },
  ds = { name = '+surround' },
  yo = { name = '+toggle' },
  gl = { name = '+lsp' },
}

which_key.register({
  ['['] = { name = '+backwards' },
  [']'] = { name = '+forwards' },
}, { mode = { 'o', 'x' } })

which_key.register({
  ['<c-g>'] = {
    g = { name = '+generate' },
  },
}, { mode = { 'n', 'v' } })
