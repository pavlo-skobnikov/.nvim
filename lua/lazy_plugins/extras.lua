return {
  {
    'Tummetott/unimpaired.nvim', -- Useful & comfy mappings for basic Vim commands
    event = 'BufEnter',
    opts = {
      default_keymaps = true,
      keymaps = {
        previous = false,
        next = false,
        first = false,
        last = false,
        bprevious = { description = 'Previous buffer' },
        bnext = { description = 'Next buffer' },
        bfirst = { description = 'First buffer' },
        blast = { description = 'Last buffer' },
        lprevious = { description = 'Previous loclist' },
        lnext = { description = 'Next loclist' },
        lfirst = { description = 'First loclist' },
        llast = { description = 'Last loclist' },
        lpfile = { description = 'Previous loclist file' },
        lnfile = { description = 'Next loclist file' },
        cprevious = { description = 'Previous qflist' },
        cnext = { description = 'Next qflist' },
        cfirst = { description = 'First qflist' },
        clast = { description = 'Last qflist' },
        cpfile = { description = 'Previous qflist file' },
        cnfile = { description = 'Next qflist file' },
        tprevious = { description = 'Previous matching tag' },
        tnext = { description = 'Next matching tag' },
        tfirst = { description = 'First matching tag' },
        tlast = { description = 'Last matching tag' },
        ptprevious = { description = ':tprevious in preview' },
        ptnext = { description = ':tnext in preview' },
        previous_file = { mapping = '[F', description = 'Previous directory file' },
        next_file = { mapping = ']F', description = 'Next directory file' },
        blank_above = { description = 'Add blank line(s) above' },
        blank_below = { description = 'Add blank line(s) below' },
        exchange_above = { description = 'Exchange above line(s)' },
        exchange_below = { description = 'Exchange below line(s)' },
        exchange_section_above = { description = 'Move section up' },
        exchange_section_below = { description = 'Move section down' },
        enable_cursorline = false,
        disable_cursorline = false,
        toggle_cursorline = { description = 'cursorline' },
        enable_diff = false,
        disable_diff = false,
        toggle_diff = { description = 'diffthis' },
        enable_hlsearch = false,
        disable_hlsearch = false,
        toggle_hlsearch = { description = 'hlsearch' },
        enable_ignorecase = false,
        disable_ignorecase = false,
        toggle_ignorecase = { description = 'ignorecase' },
        enable_list = false,
        disable_list = false,
        toggle_list = { description = 'listchars' },
        enable_number = false,
        disable_number = false,
        toggle_number = { description = 'Line numbers' },
        enable_relativenumber = false,
        disable_relativenumber = false,
        toggle_relativenumber = { description = 'Relative numbers' },
        enable_spell = false,
        disable_spell = false,
        toggle_spell = { description = 'Spell check' },
        enable_background = false,
        disable_background = false,
        toggle_background = { description = 'Background' },
        enable_colorcolumn = false,
        disable_colorcolumn = false,
        toggle_colorcolumn = { description = 'colorcolumn' },
        enable_cursorcolumn = false,
        disable_cursorcolumn = false,
        toggle_cursorcolumn = { description = 'cursorcolumn' },
        enable_virtualedit = false,
        disable_virtualedit = false,
        toggle_virtualedit = { description = 'virtualedit' },
        enable_wrap = false,
        disable_wrap = false,
        toggle_wrap = { description = 'Line wrapping' },
        enable_cursorcross = false,
        disable_cursorcross = false,
        toggle_cursorcross = { description = 'cursorcross (x)' },
      },
    },
    config = function(_, opts) require('unimpaired').setup(opts) end,
  },
  {
    'mbbill/undotree', -- A detailed undo history for files
    keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undotree' } },
  },
  {
    {
      'christoomey/vim-tmux-navigator', -- Seamless navitation between Vim and Tmux splits
      keys = {
        { '<C-h>', '<CMD>TmuxNavigateLeft<CR>', desc = 'Move a split left' },
        { '<C-j>', '<CMD>TmuxNavigateDown<CR>', desc = 'Move a split down' },
        { '<C-k>', '<CMD>TmuxNavigateUp<CR>', desc = 'Move a split up' },
        { '<C-l>', '<CMD>TmuxNavigateRight<CR>', desc = 'Move a split right' },
      },
      config = function()
        vim.cmd [[
          let g:tmux_navigator_no_mappings = 1
          let g:tmux_navigator_save_on_switch = 2
        ]]
      end,
    },
  },
  {
    'folke/which-key.nvim', -- Mapping keys like it's nothing
    event = 'VeryLazy',
    config = function()
      local which_key = require 'which-key'

      which_key.register {
        c = {
          r = {
            name = '+refactor',
            m = { name = '+major' },
          },
          d = {
            name = '+dap',
            b = { name = '+breakpoint' },
            f = { name = '+find' },
            r = { name = '+run' },
            s = { name = '+step' },
            w = { name = '+widgets' },
          },
          g = { name = '+goto' },
          s = { name = '+surround' },
        },
        ys = { name = '+surround' },
        ds = { name = '+surround' },
        yo = { name = '+toggle' },
        gl = { name = '+lsp' },
        ['<localleader>'] = {
          c = { name = '+connect' },
          e = { name = '+evaluate', c = { name = '+comment' } },
          g = { name = '+get' },
          l = { name = '+log' },
          r = { name = '+run' },
          s = { name = '+sessions' },
          v = { name = '+variables' },
          t = { name = '+test' },
        },
      }

      which_key.register({
        ['['] = { name = '+backwards' },
        [']'] = { name = '+forwards' },
      }, { mode = { 'o', 'x' } })

      which_key.register({
        ['<c-g>'] = {
          g = { name = '+generate' },
        },
      }, { mode = { 'n', 'v' } })
    end,
  },
}
