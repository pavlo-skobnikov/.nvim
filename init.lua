-- Register a keymap with the which-key plugin
---@param mapTable table The table names, mappings, and descriptions
---@param optsTable table | nil The options for the which-key plugin
function RegisterWK(mapTable, optsTable)
    local wk = require 'which-key'

    if optsTable == nil then
        wk.register(mapTable)
    else
        wk.register(mapTable, optsTable)
    end
end

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

-- USER SETTINGS
require 'autocommands'
require 'options'
require 'shared'

-- LOAD PLUGINS
require('lazy').setup 'plugins' -- Loads each lua/plugin/*

-- LOAD MAPPINGS
require 'mappings'
