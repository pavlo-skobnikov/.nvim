-- Modes -> for reference
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
--   operator_pending_mode = 'o'

U.register_keys {
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
}

U.register_keys({
  d = { '"_d', 'Delete without copying' },
}, { prefix = '<leader>', mode = 'v' })

U.register_keys({
  p = { '"_dP', 'Paste without copying' },
}, { prefix = '<leader>', mode = { 'v', 'x' } })

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('LspAttach', {
  group = augroup('SetLspKeymappings', { clear = true }),
  pattern = { '*' },
  callback = function(e)
    local buffer = vim.lsp.buf
    local diagnostic = vim.diagnostic
    local codelens = vim.lsp.codelens
    local telescope_builtin = require 'telescope.builtin'

    local opts = { buffer = e.buf }

    U.register_keys({
      ['<leader>r'] = {
        name = 'refactor',
        a = { buffer.code_action, 'Code action & save' },
        l = { codelens.run, 'Run code lens' },

        n = { buffer.rename, 'Rename' },
        h = { buffer.document_highlight, 'Highlight symbol' },

        f = { diagnostic.open_float, 'Open float' },

        r = { telescope_builtin.lsp_references, 'Search references' },
        d = { telescope_builtin.lsp_document_symbols, 'Search document symbols' },
        w = { telescope_builtin.lsp_dynamic_workspace_symbols, 'Search workspace symbols' },
      },
      g = {
        d = { telescope_builtin.lsp_definitions, 'Go to definition' },
        l = {
          name = 'lsp',
          t = { buffer.type_definition, 'Go to type definition' },
          i = { buffer.implementation, 'Go to implementation' },
          O = { telescope_builtin.lsp_outgoing_calls, 'Search outgoing calls' },
          I = { telescope_builtin.lsp_incoming_calls, 'Search incoming calls' },
        },
      },
      ['[d'] = { diagnostic.goto_prev, 'Previous diagnostic' },
      [']d'] = { diagnostic.goto_next, 'Next diagnostic' },
      K = { buffer.hover, 'Hover' },
    }, opts)

    U.register_keys({
      ['<c-s-k>'] = { buffer.signature_help, 'Signature help' },
    }, { mode = { 'n', 'v', 'i' } })
  end,
  desc = 'Set LSP key mappings that are universal to all LSP clients',
})
