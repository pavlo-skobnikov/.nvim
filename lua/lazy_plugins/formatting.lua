local function get_buffer_fname() return vim.api.nvim_buf_get_name(0) end

return {
  'mhartington/formatter.nvim', -- Easy formatter setup goodness
  dependencies = { 'williamboman/mason.nvim', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
  event = 'VeryLazy',
  opts = { logging = true, log_level = vim.log.levels.WARN },
  config = function(_, opts)
    local filetypesAndFormatters = {
      c = { require('formatter.filetypes.c')['clangformat'] },
      zig = { require('formatter.filetypes.zig')['zigfmt'] },
      rust = { require('formatter.filetypes.rust')['rustfmt'] },
      lua = { require('formatter.filetypes.lua')['stylua'] },
      python = { require('formatter.filetypes.python')['black'] },
      go = { require('formatter.filetypes.go')['goimports'] },
      java = { function() return { exe = 'google-java-format', args = { '-a', get_buffer_fname() }, stdin = true } end },
      clojure = { function() return { exe = 'cljfmt', args = { 'fix', get_buffer_fname() }, stdin = false } end },
      kotlin = { require('formatter.filetypes.kotlin')['ktlint'] },
      scala = { function() pcall(vim.lsp.buf.format) end },
      javascript = { require 'formatter.defaults.prettier' },
      typescript = { require 'formatter.defaults.prettier' },
      sh = { require('formatter.filetypes.sh')['shfmt'] },
      bash = { require('formatter.filetypes.sh')['shfmt'] },
      zsh = { require('formatter.filetypes.sh')['shfmt'] },
      markdown = { require 'formatter.defaults.prettier' },
      sql = { require 'formatter.defaults.prettier' },
      yaml = { require 'formatter.defaults.prettier' },
      json = { require 'formatter.defaults.prettier' },
      ['*'] = { require('formatter.filetypes.any')['remove_trailing_whitespace'] },
    }

    local extended_opts = vim.tbl_extend('error', opts, { filetype = filetypesAndFormatters })

    require('formatter.init').setup(extended_opts)

    UTIL.register_keys { ['<leader>='] = { ':Format<cr>', 'Format' } }
  end,
}
