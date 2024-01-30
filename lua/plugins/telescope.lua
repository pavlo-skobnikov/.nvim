return {
   {
      'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder over lists
      branch = '0.1.x',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-tree/nvim-web-devicons',
         'folke/which-key.nvim',
      },
      event = 'VeryLazy',
      opts = {
         defaults = {
            dynamic_preview_title = true,
            path_display = { 'tail' },
            layout_strategy = 'vertical',
            layout_config = { vertical = { mirror = false } },
            pickers = { lsp_incoming_calls = { path_display = 'tail' } },
         },
      },
      config = function(_, opts)
         PG.req_telescope().setup(opts)
         local telescope_builtin = PG.req_telescope_builtin()

         PG.reg_wk({
            b = { telescope_builtin.buffers, 'Buffers' },
            c = { telescope_builtin.commands, 'Command && run' },
            d = { telescope_builtin.command_history, 'In command history' },
            e = { telescope_builtin.spell_suggest, 'Spelling suggestion && apply' },
            f = {
               function()
                  telescope_builtin.find_files({
                     find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
                  })
               end,
               'All files',
            },
            g = { telescope_builtin.live_grep, 'grep search' },
            h = { telescope_builtin.help_tags, 'Doc help' },
            k = { telescope_builtin.keymaps, 'Keymaps' },
            l = { telescope_builtin.loclist, 'In loclist' },
            m = { telescope_builtin.marks, 'Marks' },
            r = { telescope_builtin.resume, 'Resume previous search' },
            s = { telescope_builtin.search_history, 'in search history' },
            q = { telescope_builtin.quickfix, 'In qflist' },
            t = { telescope_builtin.tags, 'Tags' },
            ['"'] = { telescope_builtin.registers, 'In registers (")' },
         }, { prefix = '<leader>f' })
      end,
   },
   {
      'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
      dependencies = 'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      config = function() PG.extend_telescope('ui-select') end,
   },
   {
      'nvim-telescope/telescope-fzf-native.nvim', -- Blazingly-fast C port of FZF for Telescope
      dependencies = 'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      build = 'make',
      config = function() PG.extend_telescope('fzf') end,
   },
}
