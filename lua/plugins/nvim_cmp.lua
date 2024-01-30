return {
   'hrsh7th/nvim-cmp', -- Autocompletion plugin
   dependencies = {
      'L3MON4D3/LuaSnip', -- Snippet engine for NeoVim
      'onsails/lspkind-nvim', -- VSCode-style completion options kinds
      'windwp/nvim-autopairs',
      'folke/which-key.nvim',
      -- SOURCES
      'saadparwaiz1/cmp_luasnip', -- Adds a `luasnip` completion source for `cmp`
      'rafamadriz/friendly-snippets', -- A bunch of snippets to use
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer', -- Current buffer completions
      'hrsh7th/cmp-path', -- Directory/file path completions
      'hrsh7th/cmp-cmdline', -- Command-line completion
      'rcarriga/cmp-dap', -- DAP REPL completion
      'petertriho/cmp-git', -- Git completion
   },
   event = 'VeryLazy',
   config = function()
      local cmp = require('cmp')
      local lua_snip = require('luasnip')
      local lsp_kind = require('lspkind')

      -- Lazy loading is required for the snippet engine to correctly detect the `luasnip` sources
      require('luasnip/loaders/from_vscode').lazy_load()

      -- Setup `cmp`
      cmp.setup({
         -- For cmp-dap
         enabled = function()
            return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
               or require('cmp_dap').is_dap_buffer()
         end,

         -- Enable snippets for `luasnip` users.
         snippet = { expand = function(args) lua_snip.lsp_expand(args.body) end },
         -- Enable icons to appear with completion options
         formatting = {
            format = lsp_kind.cmp_format({
               with_text = true,
               menu = {
                  buffer = '📝',
                  nvim_lsp = '💡',
                  path = '⛰️',
                  luasnip = '✂️',
               },
            }),
         },
         -- Set source priority for appearing in completion prompts
         sources = {
            { name = 'path' },
            { name = 'nvim_lsp' },
            { name = 'luasnip', keyword_length = 2 },
            { name = 'buffer', keyword_length = 4 },
         },
         --
         mapping = {
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-y>'] = cmp.mapping(
               cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
               }),
               { 'i', 'c' }
            ),
            ['<C-S-y>'] = cmp.mapping(
               cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = false,
               }),
               { 'i', 'c' }
            ),
            ['<C-Space>'] = cmp.mapping({
               i = cmp.mapping.complete(),
               c = function()
                  if cmp.visible() then
                     if not cmp.confirm({ select = true }) then return end
                  else
                     cmp.complete()
                  end
               end,
            }),
            ['<Tab>'] = cmp.config.disable,
         },
      })

      -- Snippet traversal when typing
      PG.reg_wk({
         ['<C-n>'] = { function() lua_snip.jump(1) end, 'Next Snippet Choice' },
         ['<C-p>'] = { function() lua_snip.jump(-1) end, 'Previous Snippet Choice' },
         ['<C-e>'] = {
            function()
               if lua_snip.choice_active() then lua_snip.change_choice(1) end
            end,
            'Next Snippet Choice',
         },
      }, { mode = { 'i', 's' }, silent = true })

      -- Context-aware completion sources setup
      cmp.setup.cmdline(
         { '/', '?' },
         { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } }
      )
      cmp.setup.cmdline(':', {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
      })
      cmp.setup.filetype(
         { 'dap-repl', 'dapui_watches', 'dapui_hover' },
         { sources = { { name = 'dap' } } }
      )
      cmp.setup.filetype(
         'gitcommit',
         { sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } }) }
      )

      -- Setup insertion of brackets on LSP completions
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local autopairs_handlers = require('nvim-autopairs.completion.handlers')
      local cmp_kind = cmp.lsp.CompletionItemKind

      cmp.event:on(
         'confirm_done',
         cmp_autopairs.on_confirm_done({
            filetypes = {
               ['*'] = {
                  ['('] = {
                     kind = { cmp_kind.Function, cmp_kind.Method },
                     handler = autopairs_handlers['*'],
                  },
               },
            },
         })
      )
   end,
}
