-- [[ Load Basic Configurations ]]
-- Register leader keys.
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Load additional basic configurations.
require 'basic-configurations'

-- [[ Lazy Plugin Manager ]]
-- Bootstrap lazy.nvim 💤
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end

vim.opt.runtimepath:prepend(lazypath)

-- Load plugin configurations.
require('lazy').setup {
  spec = 'custom_plugins',
  change_detection = { notify = false },
}
