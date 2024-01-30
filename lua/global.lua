-- This file contains function definitions that are to be reused in other configuration files

-- MODULE DEFINITION
local M = {}

-- Commonly required plugin modules
function M.req_repeate_move() return require('nvim-treesitter.textobjects.repeatable_move') end
function M.req_telescope() return require('telescope') end
function M.req_telescope_builtin() return require('telescope.builtin') end

-- Reqister a Telescope extension
function M.extend_telescope(ext) return M.req_telescope().load_extension(ext) end

-- Register a keymap with the which-key plugin
---@param maps table The table names, mappings, and descriptions
---@param opts table | nil The options for the which-key plugin
function M.reg_wk(maps, opts) require('which-key').register(maps, opts) end

-- Set the tab spaces for neovim from user input.
function M.set_tab_spaces(spaces_count)
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

-- Register common LSP keymaps
function M.shared_on_attach_lsp(client, bufnr)
   -- Utility definitions & functions
   local opts = { silent = true, buffer = bufnr, remap = false }

   local function extend_map_opts(values) return vim.tbl_extend('force', opts, values) end
   local function add_maps_for_active_lsp_capabilities(wk_map_table, capabilities_and_maps)
      for capability, mappings in pairs(capabilities_and_maps) do
         if client.server_capabilities[capability] then
            for key, value in pairs(mappings) do
               wk_map_table[key] = value
            end
         end
      end

      return wk_map_table
   end

   -- Requires & aliases
   local buf = vim.lsp.buf
   local diagnostic = vim.diagnostic
   local telescope_builtin = require('telescope.builtin')
   local repeat_move = M.req_repeate_move()

   -- Basic info actions
   M.reg_wk({ K = { buf.hover, 'Show kind' } }, extend_map_opts({ mode = { 'n', 'v' } }))
   M.reg_wk(
      { ['<C-S-k>'] = { buf.signature_help, 'Show function parameter info' } },
      extend_map_opts({ mode = { 'n', 'i' } })
   )

   -- Next/previous diagnostic
   local next_diagnostic_fn, prev_diagnostic_fn =
      repeat_move.make_repeatable_move_pair(diagnostic.goto_next, diagnostic.goto_prev)

   M.reg_wk({
      [']d'] = { next_diagnostic_fn, 'Next diagnostic' },
      ['[d'] = { prev_diagnostic_fn, 'Previous diagnostic' },
   }, opts)

   -- Go to LSP capability actions
   local goToLspActionMappings = add_maps_for_active_lsp_capabilities({}, {
      ['definitionProvider'] = { d = { buf.definition, 'Go to definition' } },
      ['declarationProvider'] = { D = { buf.declaration, 'Go to declaration' } },
      ['implementationProvider'] = { I = { buf.implementation, 'Go to implementation' } },
      ['callHierarchyProvider'] = {
         o = { buf.outgoing_calls, 'Search outgoing calls' },
         i = { buf.incoming_calls, 'Search incoming calls' },
      },
      ['typeDefinitionProvider'] = { t = { buf.type_definition, 'Go to type definition' } },
      ['referencesProvider'] = { r = { buf.references, 'Search references' } },
   })

   M.reg_wk(goToLspActionMappings, extend_map_opts({ prefix = 'g' }))

   -- 'Refactor' actions
   local function get_diagnostics_fn(severity)
      return function() telescope_builtin.diagnostics({ severity = diagnostic.severity[severity] }) end
   end

   local refactorActionMappings = add_maps_for_active_lsp_capabilities({
      name = 'refactor',
      f = { diagnostic.open_float, 'Diagnostics float' },
      l = { vim.lsp.codelens.run, 'Code lens' },
      s = {
         name = 'show',
         w = { get_diagnostics_fn('WARN'), 'Warnings' },
         e = { get_diagnostics_fn('ERROR'), 'Errors' },
      },
   }, {
      ['codeActionProvider'] = { a = { buf.code_action, 'Actions' } },
      ['renameProvider'] = { n = { buf.rename, 'Rename' } },
      ['documentHighlightProvider'] = { h = { buf.document_highlight, 'Highlight symbol' } },
      ['documentSymbolProvider'] = {
         d = { telescope_builtin.lsp_document_symbols, 'Search document symbols' },
      },
      ['workspaceSymbolProvider'] = {
         w = { telescope_builtin.lsp_workspace_symbols, 'Search workspace symbols' },
      },
   })

   M.reg_wk(refactorActionMappings, extend_map_opts({ prefix = '<leader>r' }))
end

-- EXPORT MODULE
return M
