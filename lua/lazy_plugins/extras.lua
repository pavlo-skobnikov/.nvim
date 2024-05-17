return {
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
  {
    'RRethy/vim-illuminate', -- Dynamic highlighting
    event = 'BufEnter',
  },
}
