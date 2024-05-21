-- 'I' in 'LLM' stands for 'Intelligence' 🧠
return {
  {
    'github/copilot.vim', -- Wait a bit get an average completion suggestion 🕰️
    event = 'InsertEnter',
    config = function() require 'plug_configs.copilot-vim' end,
  },
  {
    'robitx/gp.nvim', -- Proompt engineering 🚀
    event = 'VeryLazy',
    config = function() require 'plug_configs.gp-nvim' end,
  },
}
