-- Moving around at the speed of sound (or more like the speed of my thought 💭).
return {
  {
    'stevearc/oil.nvim', -- Vim-buffer-like file explorer 🛢️
    lazy = false,
    priority = 999,
    config = function()
      require('oil').setup {
        -- Show files and directories that start with ".".
        view_options = { show_hidden = true },
        -- Remap split mappings. Also done to not interfere with vim-tmux-navigator.
        keymaps = {
          ['<C-h>'] = false,
          ['<C-x>'] = 'actions.select_split',
          ['<C-s>'] = false,
          ['<C-v>'] = 'actions.select_vsplit',
          ['<C-l>'] = false,
          ['<C-r>'] = 'actions.refresh',
        },
      }

      Set('n', '-', '<cmd>Oil<cr>', { desc = 'File explorer' })
    end,
  },
  {
    'ThePrimeagen/harpoon', -- Pin files and switch between them quickly 🗃️
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup()

      SetG('n', 'ha', function() harpoon:list():add() end, { desc = 'Add file' })
      SetG('n', 'hl', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'List files' })
      Set('n', '[h', function() harpoon:list():prev() end, { desc = 'Previous mark' })
      Set('n', ']h', function() harpoon:list():next() end, { desc = 'Next mark' })

      --[[
        Keep the amount of quickly accessible marks to a minimum.

        1 to 5 range is enough for most use cases and is kept consistent in access i.e. the left hand
        handles direct access to the marks.
      --]]
      for i = 1, 5 do
        Set('n', 'g' .. i, function() harpoon:list():select(i) end, { desc = 'Go to Harpoon mark ' .. i })
      end
    end,
  },
  {
    'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder 🔭
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
      {
        'nvim-telescope/telescope-fzf-native.nvim', -- Blazingly-fast C port of FZF for Telescope.
        build = 'make',
      },
    },
    event = 'VeryLazy',
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          dynamic_preview_title = true,
          path_display = { 'tail' },
          layout_strategy = 'vertical',
          layout_config = { vertical = { mirror = false } },
          pickers = { lsp_incoming_calls = { path_display = 'tail' } },
        },
        extensions = {
          fzf = {},
        },
      }

      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'

      local builtin = require 'telescope.builtin'

      -- Basic actions
      Set('n', '<M-x>', builtin.commands, { desc = 'Search and execute commands' })
      Set('n', '<M-/>', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy search in buffer' })

      SetG('n', 'fa', '<cmd>Telescope<cr>', { desc = 'Telescope actions' })
      SetG('n', 'fr', builtin.resume, { desc = 'Resume previous search' })
      SetG('n', 'f<C-h>', builtin.help_tags, { desc = 'Help tags' })

      SetG('n', 'ff', builtin.find_files, { desc = 'Files' })
      SetG('n', 'fh', builtin.oldfiles, { desc = 'File history' })

      SetG('n', 'fg', builtin.live_grep, { desc = 'grep' })

      SetG('n', 'fq', builtin.quickfix, { desc = 'Quickfix' })
      SetG('n', 'fQ', builtin.quickfixhistory, { desc = 'Quickfix history' })
      SetG('n', 'fR', builtin.registers, { desc = 'Registers' })

      -- Git
      SetG('n', 'gc', builtin.git_commits, { desc = 'Commits' })
      SetG('n', 'gC', builtin.git_bcommits, { desc = 'Buffer commits' })
      SetG('n', 'gB', builtin.git_branches, { desc = 'Branches' })
      SetG('n', 'gs', builtin.git_status, { desc = 'Status' })
      SetG('n', 'gS', builtin.git_stash, { desc = 'Stash' })
    end,
  },
}
