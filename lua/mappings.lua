-- Modes -> for reference
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
--   operator_pending_mode = 'o'

UTIL.register_keys {
  ['<esc>'] = {
    function()
      vim.cmd ':noh'
      vim.cmd ':call clearmatches()'
      vim.lsp.buf.clear_references()
    end,
    'Remove all highlights',
  },

  ['<c-d>'] = { '<C-d>zz', 'Screen down and center' },
  ['<c-u>'] = { '<C-u>zz', 'Screen up and center' },

  ['d<space>'] = { 'f<space>diwi<space><esc>', 'Trim whitespace' },
  ['c<space>'] = { 'f<space>diwi<space>', 'Trim whitespace' },

  ['g*'] = { function() vim.fn.matchadd('Search', vim.fn.expand '<cword>') end, 'Highlight word under cursor' },

  ['<leader>C'] = {
    name = 'configure',
    s = { function() UTIL.set_tab_spaces(tonumber(vim.fn.input 'Spaces count > ')) end, 'Set tab spaces' },
  },
}

for i = 1, 9 do
  UTIL.register_keys { ['<leader>' .. i] = { i .. '<c-w>w', 'Go to window ' .. i } }
end

UTIL.register_keys({
  d = { '"_d', 'Delete without copying' },
}, { prefix = '<leader>', mode = 'v' })

UTIL.register_keys({
  p = { '"_dp', 'Paste without copying' },
}, { prefix = '<leader>', mode = { 'v', 'x' } })

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('LspAttach', {
  group = augroup('SetLspKeymappings', { clear = true }),
  pattern = { '*' },
  callback = function(e)
    local buf = vim.lsp.buf
    local diagnostic = vim.diagnostic
    local codelens = vim.lsp.codelens
    local telescope_builtin = require 'telescope.builtin'

    local opts = { buffer = e.buf }

    UTIL.register_keys({
      g = {
        a = { buf.code_action, 'Code action' },
        s = { telescope_builtin.lsp_document_symbols, 'Search document symbols' },
        S = { telescope_builtin.lsp_workspace_symbols, 'Search workspace symbols' },
        d = { buf.definition, 'Go to definition' },
        D = { buf.type_definition, 'Go to type definition' },
        h = { buf.implementation, 'Go to implementation hierarchy' },
        H = { buf.document_highlight, 'Highlight symbol' },
        L = { codelens.run, 'Code lens' },
        R = { buf.rename, 'Rename' },
        o = { diagnostic.open_float, 'Open float' },
        O = { buf.outgoing_calls, 'Search outgoing calls' },
        I = { buf.incoming_calls, 'Search incoming calls' },
      },
      ['[d'] = { diagnostic.goto_prev, 'Previous diagnostic' },
      [']d'] = { diagnostic.goto_next, 'Next diagnostic' },
      K = { buf.hover, 'Hover' },
    }, opts)

    UTIL.register_keys({
      ['<c-m-k>'] = { buf.signature_help, 'Signature help' },
    }, { mode = { 'n', 'v', 'i' } })
  end,
  desc = 'Set LSP key mappings that are universal to all LSP clients',
})
