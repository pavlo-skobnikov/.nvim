return {
  'Olical/conjure', -- Interactive environment for evaluating code within a running program
  dependencies = {
    'tpope/vim-dispatch', -- Asynchronous execution for Neovim
    'clojure-vim/vim-jack-in', -- Auto-setup Boot, Clj & Leiningen sessions from the command mode
  },
  ft = { 'clojure' },
}
