--[[
Register _fake_ leader keys.

- Why the need for _fake_ leader keys?
- NeoVim doesn't support leader keys with modifiers, so, instead
  I use a custom function to map keys to the actual leader key.
--]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


--[[
Define global variables for leader and localleader keys.

- Why use <C-...> instead of <SPACE> and similar?
- This allows to have consistent keybindings across NeoVim and
  IntelliJ as GUI apps usually allow to create "chord" keybindings
  that start with key combinations _with_ modifiers.

NOTE: Emacs uses <C-c> as the leader key for local keybindings. However, that
  mapping is usually reserver for cancelling operations in the terminal. So, instead
  I've chosen <C-g> as the local leader key as it's the Emacs's "abort" keybinding.
--]]
P = {
  leader = '<C-a>', -- [A]ctions
  localleader = '<C-x>', -- E[x]tras
}

-- Shorter alias for setting key mappings.
function Set(modes, keys, action, options)
  vim.keymap.set(modes, keys, action, options)
end

-- Map keys to the "global" leader key.
function SetG(modes, keys, action, options)
  Set(modes, P.leader .. keys, action, options)
end

-- Map keys to the "local" leader key.
function SetL(modes, keys, action, options)
  Set(modes, P.localleader .. keys, action, options)
end

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
