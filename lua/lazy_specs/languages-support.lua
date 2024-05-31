-- Typing is too hard 🌚
return {
  {
    -- Language-agnostic support plugins.
    'hrsh7th/nvim-cmp', -- Autocompletion plugin ✅
    dependencies = {
      -- Core.
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
      'onsails/lspkind-nvim',
      -- Sources
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'rcarriga/cmp-dap',
      'petertriho/cmp-git',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function() require 'plug_configs.nvim-cmp' end,
  },
  {
    'mhartington/formatter.nvim', -- Easy formatter setup goodness.
    event = 'VeryLazy',
    config = function() require 'plug_configs.formatter-nvim' end,
  },
  {
    'williamboman/mason-lspconfig.nvim', -- Bridges mason.nvim with the lspconfig plugin.
    dependencies = {
      { 'williamboman/mason.nvim', build = ':MasonUpdate' },
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'VeryLazy',
    config = function() require 'plug_configs.mason-lspconfig' end,
  },
  {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client.
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope.nvim',
    },
    event = 'VeryLazy',
    config = function() require 'plug_configs.nvim-dap' end,
  },
  -- Language-specific support plugins.
  {
    'ray-x/go.nvim', -- Go support.
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-treesitter/nvim-treesitter', 'ray-x/guihua.lua' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    config = function() require 'plug_configs.go-nvim' end,
  },
  {
    'nvim-java/nvim-java', -- Java support.
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = { registries = { 'github:nvim-java/mason-registry', 'github:mason-org/mason-registry' } },
      },
    },
    ft = { 'java' },
    config = function() require 'plug_configs.nvim-java' end,
  },
  {
    'mfussenegger/nvim-dap-python', -- Python debugging support.
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = { 'python' },
    config = function() require 'plug_configs.nvim-dap-python' end,
  },
  {
    'scalameta/nvim-metals', -- Scala support.
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt' },
    config = function() require 'plug_configs.nvim-metals' end,
  },
}
