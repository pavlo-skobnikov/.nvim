local function req_ts_configs() return require('nvim-treesitter.configs') end

return {
   {
      'nvim-treesitter/nvim-treesitter', -- Syntax highlighting
      dependencies = { 'folke/which-key.nvim' },
      event = 'VeryLazy',
      build = ':TSUpdate',
      opts = {
         ensure_installed = {
            'c', -- Required for Treesitter to function parsers
            'lua',
            'vim',
            'vimdoc',
            'query',
            'diff', -- Additional parsers
            'gitattributes',
            'gitcommit',
            'gitignore',
            'http',
            'comment',
            'markdown',
            'json',
            'dockerfile',
            'yaml',
            'terraform',
            'hcl',
            'sql',
            'java',
         },

         sync_install = false, -- Install parsers synchronously
         auto_install = true, -- Auto-install missing parsers when entering buffer
         highlight = { enable = true, additional_vim_regex_highlighting = false },
         indent = { enable = false },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = 'gs',
               node_incremental = ';',
               node_decremental = ',',
               scope_incremental = false,
            },
         },
      },
      config = function(_, opts)
         req_ts_configs().setup(opts)

         vim.cmd([[ " Treesitter folding
                set foldmethod=expr
                set foldexpr=nvim_treesitter#foldexpr()
                set nofoldenable " Disable folding at startup.
            ]])
      end,
   },
   {
      'nvim-treesitter/nvim-treesitter-textobjects', -- Additional Vim textobjects
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
      event = 'VeryLazy',
      opts = {
         textobjects = {
            select = {
               enable = true,
               lookahead = true,
               keymaps = {
                  ['ie'] = { query = '@parameter.inner', desc = 'inner argument element' },
                  ['ae'] = { query = '@parameter.outer', desc = 'around argument element' },
                  ['if'] = { query = '@function.inner', desc = 'inner function' },
                  ['af'] = { query = '@function.outer', desc = 'around function' },
               },
            },
            swap = {
               enable = true,
               swap_next = {
                  ['>e'] = { query = '@parameter.inner', desc = 'Swap argument forwards' },
                  ['>f'] = { query = '@function.outer', desc = 'Swap function forwards' },
               },
               swap_previous = {
                  ['<e'] = { query = '@parameter.inner', desc = 'Swap argument backwards' },
                  ['<f'] = { query = '@function.outer', desc = 'Swap function backwards' },
               },
            },
            move = {
               enable = true,
               set_jumps = true,
               goto_next_start = {
                  [']a'] = { query = '@parameter.inner', desc = 'Next argument' },
                  [']f'] = { query = '@function.outer', desc = 'Next function' },
               },
               goto_previous_start = {
                  ['[a'] = { query = '@parameter.inner', desc = 'Previous argument' },
                  ['[f'] = { query = '@function.outer', desc = 'Previous function' },
               },
            },
         },
      },
      config = function(_, opts)
         req_ts_configs().setup(opts)

         PG.reg_wk({ ['['] = 'backwards', [']'] = 'forwards' }, { mode = { 'o', 'x' } })

         local rm = PG.req_repeate_move()

         PG.reg_wk({
            [';'] = { rm.repeat_last_move_next, 'Repeat last move forwards' },
            [','] = { rm.repeat_last_move_previous, 'Repeat last move backwards' },
            ['f'] = { rm.builtin_f, 'Search char forwards' },
            ['F'] = { rm.builtin_F, 'Search char backwards' },
            ['t'] = { rm.builtin_t, 'Search until char forwards' },
            ['T'] = { rm.builtin_T, 'Search until char backwards' },
         }, { mode = { 'n', 'x', 'o' } })
      end,
   },
   {
      'nvim-treesitter/playground', -- Treesitter query playground
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'folke/which-key.nvim' },
      event = 'VeryLazy',
      config = function()
         PG.reg_wk({
            p = {
               name = 'ts-playground',
               p = { ':TSPlaygroundToggle<cr>', 'Toggle playground' },
               h = { ':TSHighlightCapturesUnderCursor<cr>', 'Highlight captures under cursor' },
               n = { ':TSNodeUnderCursor<cr>', 'Highlight node under cursor' },
            },
         }, { prefix = '<leader>' })
      end,
   },
}
