-- Mapping key descriptions like it's nothing 🎆
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local which_key = require 'which-key'

    which_key.register {
      ['<LEADER>'] = {
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
        h = { name = '+harpoon' },
        l = {
          name = '+lsp',
          c = { name = '+calls' },
          d = { name = '+diagnostics' },
          g = { name = '+goto' },
          s = { name = '+symbols' },
        },
        t = { name = '+toggle' },
        s = { name = '+swap' },
      },
      ds = { name = '+surround' },
      gl = {
        name = '+lsp',
        c = { name = '+calls' },
        e = { name = '+errors' },
        s = { name = '+symbols' },
      },
      s = { name = '+surround' },
      ys = { name = '+surround' },
      z = { name = '+fold' },
    }

    which_key.register({
      ['<LEADER>'] = {
        c = {
          name = '+chat-gpt',
          g = { name = '+generate' },
        },
        d = {
          name = '+dap',
          w = { name = '+widgets' },
        },
        j = { name = '+jump' },
        g = {
          name = '+git',
          h = { name = '+hunk' },
        },
        l = { name = '+lsp' },
        n = { name = '+notes' },
      },
    }, { mode = { 'n', 'v' } })

    which_key.register({
      g = { name = '+goto' },
      ['['] = { name = '+backwards' },
      [']'] = { name = '+forwards' },
    }, { mode = { 'n', 'o', 'x' } })
  end,
}
