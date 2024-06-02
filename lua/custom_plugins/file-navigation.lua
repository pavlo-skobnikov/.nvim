-- Moving around at the speed of sound (or more like the speed of my thought 💭).
return {
  { -- Vim-buffer-like file explorer 🛢️
    'stevearc/oil.nvim',
    lazy = false,
    priority = 999,
    keys = { { '-', '<cmd>Oil<cr>', desc = 'File explorer' } },
    opts = {
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
    },
  },
  { -- Pin files and switch between them quickly 🗃️
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
      local harpoon = require 'harpoon'

      local mappings = {
        { Leader .. 'ha', function() harpoon:list():add() end, desc = 'Add file' },
        {
          Leader .. 'hl',
          function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,

          desc = 'List files',
        },
        { '[h', function() harpoon:list():prev() end, desc = 'Previous Harpoon mark' },
        { ']h', function() harpoon:list():next() end, desc = 'Next Harpoon mark' },
      }

      for i = 1, 5 do
        table.insert(mappings, { 'g' .. i, function() harpoon:list():select(i) end, desc = 'Go to Harpoon mark ' .. i })
      end

      return mappings
    end,
  },
  { -- An incredibly extendable fuzzy finder 🔭
    'nvim-telescope/telescope.nvim',
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
    keys = function()
      local builtin = require 'telescope.builtin'

      return {
        -- Basic actions
        { '<M-x>', builtin.commands, desc = 'Search and execute commands' },
        { '<M-/>', builtin.current_buffer_fuzzy_find, desc = 'Fuzzy search in buffer' },

        { Leader .. 'fa', '<cmd>Telescope<cr>', desc = 'Telescope actions' },
        { Leader .. 'fr', builtin.resume, desc = 'Resume search' },
        { Leader .. 'f<C-h>', builtin.help_tags, desc = 'Help tags' },

        { Leader .. 'ff', builtin.find_files, desc = 'Find files' },
        { Leader .. 'fh', builtin.oldfiles, desc = 'Opened files history' },

        { Leader .. 'fg', builtin.live_grep, desc = 'grep' },

        { Leader .. 'fq', builtin.quickfix, desc = 'Quickfix list' },
        { Leader .. 'fQ', builtin.quickfixhistory, desc = 'Quickfix list' },
        { Leader .. 'fR', builtin.registers, desc = 'Registers' },

        -- Git
        { Leader .. 'gc', builtin.git_commits, desc = 'Commits' },
        { Leader .. 'gC', builtin.git_bcommits, desc = 'Buffer commits' },
        { Leader .. 'gB', builtin.git_branches, desc = 'Branches' },
        { Leader .. 'gs', builtin.git_status, desc = 'Status' },
        { Leader .. 'gS', builtin.git_stash, desc = 'Stash' },
      }
    end,
    opts = {
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
    },
    config = function(_, opts)
      local telescope = require 'telescope'

      telescope.setup(opts)

      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
    end,
  },
}
