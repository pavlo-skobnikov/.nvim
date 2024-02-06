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

-- Load base nvim configurations
require 'autocommands'
require 'options'

-- Shared utility functions
UTIL = require 'utilities'

-- Load plugin configurations
require('lazy').setup 'lazy_plugins' -- Loads each lua/lazy_plugins/*

-- Load extra key mappings
require 'mappings'
