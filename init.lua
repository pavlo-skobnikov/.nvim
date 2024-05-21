-- REGISTER LEADER KEYS
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- BOOTSTRAP LAZY.NVIM
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

-- Load plugin configurations
require('lazy').setup {
  spec = 'lazy_specs',
  change_detection = { notify = false },
}
