-- This file contains functions to be used in configuration files.
local MODULE = {}

-- Register a keymap with the which-key plugin
---@param maps table The table names, mappings, and descriptions
---@param opts table | nil The options for the which-key plugin
function MODULE.register_keys(maps, opts) require('which-key').register(maps, opts) end

-- Set the tab spaces for neovim from user input.
function MODULE.set_tab_spaces(spaces_count)
  vim.opt.shiftwidth = spaces_count
  vim.opt.tabstop = spaces_count
  vim.opt.listchars = {
    tab = '>·',
    leadmultispace = '⎸' .. string.rep(' ', spaces_count - 1),
    extends = '▸',
    precedes = '◂',
    trail = '·',
  }
end

-- Create a user command to set the tab spaces
vim.api.nvim_create_user_command(
  'SetTabSpaces',
  function(opts) MODULE.set_tab_spaces(tonumber(opts.fargs[1])) end,
  { nargs = 1 }
)

return MODULE
