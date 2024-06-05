-- Autocompletion plugin ✅
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Core.
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
    },
    'onsails/lspkind-nvim',
    -- Completion sources.
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
  config = function()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    local luasnip = require 'luasnip'

    -- Setup lspkind.
    lspkind.init()

    -- Setup cmp.
    local cmp_mappping_override = {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<TAB>'] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        { 'i', 's', 'c' }
      ),
    }

    cmp.setup {
      -- Set source priority for appearing in completion prompts.
      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 4 },
      },

      -- Set up key mappings for completion.
      mapping = cmp.mapping.preset.insert(cmp_mappping_override),

      -- Enable luasnip to handle snippet expansion for nvim-cmp.
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },

      -- Set up cmp-dap integration.
      enabled = function()
        return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
      end,
    }

    -- Context-aware completion sources setup
    cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    })
    cmp.setup.filetype(
      { 'dap-repl', 'dapui_watches', 'dapui_hover' },
      { mapping = cmp.mapping.preset.insert(cmp_mappping_override), sources = { { name = 'dap' } } }
    )
    cmp.setup.filetype('gitcommit', {
      mapping = cmp.mapping.preset.insert(cmp_mappping_override),
      sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } }),
    })

    -- Set up luasnip.
    luasnip.config.set_config {
      history = false,
      updateevents = 'TextChanged,TextChangedI',
    }

    -- Snippet traversal mappings.
    vim.keymap.set({ 'i', 's' }, '<C-n>', function() return luasnip.jump(1) end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-p>', function() return luasnip.jump(-1) end, { silent = true })
  end,
}
