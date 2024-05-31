-- Register leader keys.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

--[[
Define global variables for custom leader key.

- Why use <M-e> instead of <SPACE> and similar?
- This allows to have consistent keybindings across NeoVim and IntelliJ.
--]]
P = {
  leader = '<M-e>',
}

-- Shorter alias for setting key mappings.
function Set(modes, keys, action, options) vim.keymap.set(modes, keys, action, options) end

-- Map keys to the "global" leader key.
function SetG(modes, keys, action, options) Set(modes, P.leader .. keys, action, options) end

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
  spec = 'lazy_specs',
  change_detection = { notify = false },
}
