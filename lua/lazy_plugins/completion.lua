return {
  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  dependencies = {
    'L3MON4D3/LuaSnip',
    'onsails/lspkind-nvim',
    'windwp/nvim-autopairs',
    -- SOURCES
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'rcarriga/cmp-dap',
    'petertriho/cmp-git',
  },
  event = { 'InsertEnter', 'CmdlineEnter' },
  keys = function()
    local lua_snip = require 'luasnip'

    return {
      -- Snippet traversal when typing
      { '<c-f>', function() lua_snip.jump(1) end, mode = { 'i', 's' }, silent = true },
      {
        '<c-e>',
        function()
          if lua_snip.choice_active() then lua_snip.change_choice(1) end
        end,
        mode = { 'i', 's' },
        silent = true,
      },
      { '<c-b>', function() lua_snip.jump(-1) end, mode = { 'i', 's' }, silent = true },
    }
  end,
  opts = function()
    local cmp = require 'cmp'
    local lua_snip = require 'luasnip'
    local lsp_kind = require 'lspkind'

    local function get_map_cfg(action) return cmp.mapping(action, { 'i', 'c' }) end

    return {
      -- For `cmp-dap`
      enabled = function()
        return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
      end,

      -- Enable snippets for `luasnip` users.
      snippet = { expand = function(args) lua_snip.lsp_expand(args.body) end },
      -- Enable icons to appear with completion options
      formatting = {
        format = lsp_kind.cmp_format {
          with_text = true,
          menu = { buffer = '📝', nvim_lsp = '💡', path = '📂', luasnip = '🔮' },
        },
      },
      -- Set source priority for appearing in completion prompts
      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 4 },
      },
      -- Key mappings for completion
      mapping = {
        ['<c-n>'] = get_map_cfg(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }),
        ['<c-p>'] = get_map_cfg(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }),
        ['<c-d>'] = get_map_cfg(cmp.mapping.scroll_docs(-4)),
        ['<c-u>'] = get_map_cfg(cmp.mapping.scroll_docs(4)),
        ['<c-e>'] = get_map_cfg(cmp.mapping.abort()),
        ['<tab>'] = get_map_cfg(cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true }),
        ['<c-space>'] = cmp.mapping { i = cmp.mapping.complete() },
      },
    }
  end,
  config = function(_, opts)
    local cmp = require 'cmp'

    -- Lazy loading is required for the snippet engine to correctly detect the `luasnip` sources
    require('luasnip/loaders/from_vscode').lazy_load()

    -- Setup `cmp`
    cmp.setup(opts)

    -- Context-aware completion sources setup
    cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    })
    cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, { sources = { { name = 'dap' } } })
    cmp.setup.filetype('gitcommit', { sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } }) })

    -- Setup insertion of brackets on LSP completions
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local autopairs_handlers = require 'nvim-autopairs.completion.handlers'
    local cmp_kind = cmp.lsp.CompletionItemKind

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done {
        filetypes = {
          ['*'] = {
            ['('] = {
              kind = { cmp_kind.Function, cmp_kind.Method },
              handler = autopairs_handlers['*'],
            },
          },
        },
      }
    )
  end,
}
