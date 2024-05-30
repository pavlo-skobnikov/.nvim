-- [[ COMMANDS ]]

-- A user command to set the tab spaces.
vim.api.nvim_create_user_command('SetTabSpaces', function(opts)
  local spaces_count = tonumber(opts.fargs[1])

  vim.opt.shiftwidth = spaces_count
  vim.opt.tabstop = spaces_count
  vim.opt.listchars = {
    tab = '>·',
    leadmultispace = '⎸' .. string.rep(' ', spaces_count - 1),
    extends = '▸',
    precedes = '◂',
    trail = '·',
  }
end, { nargs = 1 })

-- [[ AUTOCOMMANDS ]]

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('FocusGained', {
  group = augroup('CheckFileForExternalChanges', { clear = true }),
  pattern = { '*' },
  callback = function() vim.cmd 'checktime' end, -- Checks if file was changed while outside of NeoVim.
  desc = "Update the file's buffer when there are changes to the file on disk",
})

local function get_git_branch_name()
  local result = vim.fn.system 'git branch --show-current'

  if string.match(result, 'fatal') then return 'NO-GIT' end

  return vim.fn.trim(result)
end

local function set_status_line() vim.opt.statusline = '%f  %r%m%=%y  (' .. get_git_branch_name() .. ')    %l,%c    %P' end

autocmd('BufEnter', {
  group = augroup('UpdateCurrentGitBranch', { clear = true }),
  pattern = { '*' },
  callback = function() set_status_line() end,
  desc = 'Update the status line with the current git branch name when entering a buffer',
})

autocmd('FileType', {
  group = augroup('SetTabTo2Spaces', { clear = true }),
  pattern = { 'scala', 'sbt', 'json', 'lua', 'gleam' },
  callback = function() vim.cmd [[ SetTabSpaces 2 ]] end,
  desc = 'Set Tab to 2 spaces for specific filetypes',
})

autocmd('BufLeave', {
  group = augroup('SaveFileOnFocusLost', { clear = true }),
  pattern = { '*' },
  callback = function() vim.cmd 'silent! wa' end,
  desc = 'Save the file when its related buffer loses focus',
})

autocmd('LspAttach', {
  group = augroup('SetLspKeymappings', { clear = true }),
  pattern = { '*' },
  callback = function(e)
    local builtin = require 'telescope.builtin'
    local function createOptions(description) return { buffer = e.buf, desc = description } end

    SetG('n', 'rr', vim.lsp.buf.code_action, createOptions 'Refactor action')
    SetG('n', 'rl', vim.lsp.codelens.run, createOptions 'Code lens')
    SetG('n', 'rn', vim.lsp.buf.rename, createOptions 'Rename')
    SetG('n', 'rh', vim.lsp.buf.document_highlight, createOptions 'Highlight')
    SetG('n', 'rf', vim.diagnostic.open_float, createOptions 'Float diagnostics')

    SetG('n', 'rgr', builtin.lsp_references, createOptions 'References')
    SetG('n', 'rgd', builtin.lsp_definitions, createOptions 'Go to definition')
    SetG('n', 'rgt', builtin.lsp_type_definitions, createOptions 'Go to type definition')
    SetG('n', 'rgi', builtin.lsp_implementations, createOptions 'Go to implementation')

    SetG('n', 'rdw', builtin.diagnostics, createOptions 'Workspace diagnostics')
    SetG('n', 'rdf', function() builtin.diagnostics { bufnr = 0 } end, createOptions 'File diagnostics')

    SetG('n', 'rsd', builtin.lsp_document_symbols, createOptions 'Document symbols')
    SetG('n', 'ssw', builtin.lsp_workspace_symbols, createOptions 'Workspace symbols')
    SetG('n', 'sss', builtin.lsp_dynamic_workspace_symbols, createOptions 'Dynamic workspace symbols')
    SetG('n', 'sst', builtin.treesitter, createOptions 'Treesitter symbols')

    SetG('n', 'rco', builtin.lsp_outgoing_calls, createOptions 'Outgoing calls')
    SetG('n', 'rci', builtin.lsp_incoming_calls, createOptions 'Incoming calls')

    SetG('n', 'K', vim.lsp.buf.hover, createOptions 'Hover')
    SetG('i', '<C-s>', vim.lsp.buf.signature_help, createOptions 'Signature help')

    SetG('n', '[d', vim.diagnostic.goto_prev, createOptions 'Previous diagnostic')
    SetG('n', ']d', vim.diagnostic.goto_next, createOptions 'Next diagnostic')
  end,
  desc = 'Set LSP key mappings',
})
