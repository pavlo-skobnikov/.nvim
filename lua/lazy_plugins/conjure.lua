return {
  'Olical/conjure', -- Interactive environment for evaluating code within a running program
  dependencies = {
    'tpope/vim-dispatch', -- Asynchronous execution for Neovim
    'clojure-vim/vim-jack-in', -- Auto-setup Boot, Clj & Leiningen sessions from the command mode
    'folke/which-key.nvim',
  },
  ft = { 'clojure' },
  config = function()
    UTIL.register_keys({
      c = 'connect',
      e = { name = 'evaluate', c = 'comment' },
      g = 'get',
      l = 'log',
      r = 'run',
      s = 'sessions',
      v = 'variables',
      t = 'test',
    }, { prefix = '<localleader>' })
  end,
}
