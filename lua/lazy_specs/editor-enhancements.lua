-- View it, snip it, yank it, code it. Now with extra comfort and speed! 🚘
return {
  {
    'windwp/nvim-autopairs', -- Even quotes and brackets shouldn't be alone, don't you think?
    event = 'InsertEnter',
    config = true,
  },
  {
    'tpope/vim-surround', -- Add, change, and delete paired surrounding characters 🎭
    event = 'BufEnter',
  },
  {
    'RRethy/vim-illuminate', -- Auto-highlighting of symbols under the cursor 💡
    event = 'BufEnter',
  },
  {
    'Tummetott/unimpaired.nvim', -- Useful & comfy mappings for basic Vim commands 🐚
    event = 'BufEnter',
    config = function()
      local function get_mapping(mapping, description)
        return {
          mapping = mapping,
          description = description,
          dot_repeat = true,
        }
      end

      local function get_leader_mapping(mapping, description) return get_mapping(Leader .. mapping, description) end

      require('unimpaired').setup {
        default_keymaps = false,
        keymaps = {
          cprevious = get_mapping('[q', 'Previous [count] qflist'),
          cnext = get_mapping(']q', 'Next [count] qflist'),
          toggle_cursorline = get_leader_mapping('tc', 'cursorline'),
          toggle_hlsearch = get_leader_mapping('th', 'hlsearch'),
          toggle_ignorecase = get_leader_mapping('ti', 'ignorecase'),
          toggle_list = get_leader_mapping('tl', 'Invisible characters (listchars)'),
          toggle_number = get_leader_mapping('tn', 'Line numbers'),
          toggle_relativenumber = get_leader_mapping('tr', 'Relative numbers'),
          toggle_spell = get_leader_mapping('ts', 'Spell check'),
          toggle_background = get_leader_mapping('tb', 'background'),
          toggle_colorcolumn = get_leader_mapping('tt', 'colorcolumn'),
          toggle_cursorcolumn = get_leader_mapping('tu', 'cursorcolumn'),
          toggle_virtualedit = get_leader_mapping('tv', 'virtualedit'),
          toggle_wrap = get_leader_mapping('tw', 'Line wrapping'),
          toggle_cursorcross = get_leader_mapping('tx', 'cursorcross'),
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter', -- Blazingly-fast syntax highlighting 🌅
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context', -- Always see the surrounding context even if it's too far up.
      'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects to play around with.
    },
    event = 'BufEnter',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c', -- Parsers required for Treesitter to function
          'lua',
          'vim',
          'vimdoc',
          'query',
          'diff', -- Additional parsers
          'gitattributes',
          'gitcommit',
          'gitignore',
          'comment',
          'markdown',
          'markdown_inline',
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

        -- Configure additional textobjects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['ia'] = { query = '@parameter.inner', desc = 'inner argument' },
              ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
              ['if'] = { query = '@function.inner', desc = 'inner function' },
              ['af'] = { query = '@function.outer', desc = 'around function' },
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
          swap = { enable = false },
        },
      }
    end,
  },
  {
    'christoomey/vim-tmux-navigator', -- Navigate seamlessly between Vim and Tmux panes 🪟
    event = 'VeryLazy',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_save_on_switch = 2

      vim.keymap.set('n', '<C-h>', '<CMD>TmuxNavigateLeft<CR>', { desc = 'Navigate window/pane left' })
      vim.keymap.set('n', '<C-j>', '<CMD>TmuxNavigateDown<CR>', { desc = 'Navigate window/pane down' })
      vim.keymap.set('n', '<C-k>', '<CMD>TmuxNavigateUp<CR>', { desc = 'Navigate window/pane up' })
      vim.keymap.set('n', '<C-l>', '<CMD>TmuxNavigateRight<CR>', { desc = 'Navigate window/pane right' })
    end,
  },
  {
    'mbbill/undotree', -- Visualize and navigate through local file modification history 📑
    event = 'VeryLazy',
    config = function() SetG('n', 'u', '<CMD>UndotreeToggle<CR>', { desc = 'Undo history' }) end,
  },
  {
    'tpope/vim-repeat', -- A helper plugin for other plugins to add dot-repeat functionality 🔧
    event = 'VeryLazy',
  },
  {
    'folke/which-key.nvim', -- Mapping keys like it's nothing 🎆
    event = 'VeryLazy',
    config = function()
      local which_key = require 'which-key'

      which_key.register {
        [Leader] = {
          name = '+leader',
          d = {
            name = '+dap',
            b = { name = '+breakpoint' },
            f = { name = '+find' },
            r = { name = '+run' },
            s = { name = '+step' },
            w = { name = '+widgets' },
          },
          f = { name = '+find' },
          h = { name = '+harpoon' },
          l = {
            name = '+lsp',
            c = { name = '+calls' },
            d = { name = '+diagnostics' },
            g = { name = '+goto' },
            s = { name = '+symbols' },
          },
          t = { name = '+toggle' },
        },
        ds = { name = '+surround' },
        gl = {
          name = '+lsp',
          c = { name = '+calls' },
          e = { name = '+errors' },
          s = { name = '+symbols' },
        },
        s = { name = '+surround' },
        ys = { name = '+surround' },
        z = { name = '+fold' },
      }

      which_key.register({
        [Leader] = {
          c = {
            name = '+chat-gpt',
            g = { name = '+generate' },
          },
          d = {
            name = '+dap',
            w = { name = '+widgets' },
          },
          g = {
            name = '+git',
            h = { name = '+hunk' },
          },
          n = { name = '+notes' },
        },
      }, { mode = { 'n', 'v' } })

      which_key.register({
        g = { name = '+goto' },
        ['['] = { name = '+backwards' },
        [']'] = { name = '+forwards' },
      }, { mode = { 'n', 'o', 'x' } })
    end,
  },
}
