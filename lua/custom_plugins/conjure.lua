-- Interactive development for Neovim 👾
return {
  'Olical/conjure',
  ft = 'clojure',
  config = function()
    require('conjure.main').main()
    require('conjure.mapping')['on-filetype']()
  end,
  init = function() vim.g['conjure#mapping#doc_word'] = 'k' end,
}
