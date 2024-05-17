-- [[ COMMANDS ]]

-- A user command to set the tab spaces
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
  callback = function() vim.cmd 'checktime' end, -- Checks if file was changed while outside of NeoVim
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
    local function createOptions(description) return { buffer = e.buf, desc = description } end

    vim.keymap.set('n', 'crr', vim.lsp.buf.code_action, createOptions 'Refactor action')
    vim.keymap.set('n', 'crl', vim.lsp.codelens.run, createOptions 'Code lens')
    vim.keymap.set('n', 'crn', vim.lsp.buf.rename, createOptions 'Rename')
    vim.keymap.set('n', 'crh', vim.lsp.buf.document_highlight, createOptions 'Highlight')
    vim.keymap.set('n', 'crf', vim.diagnostic.open_float, createOptions 'Float diagnostics')


    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, createOptions 'Definition')
    vim.keymap.set('n', 'glt', vim.lsp.buf.type_definition, createOptions 'Type definition')

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, createOptions 'References')
    vim.keymap.set('n', 'gld', vim.lsp.buf.document_symbol, createOptions 'Document symbols')
    vim.keymap.set('n', 'glw', vim.lsp.buf.workspace_symbol, createOptions 'Workspace symbols')

    vim.keymap.set('n', 'gli', vim.lsp.buf.implementation, createOptions 'Implementation')
    vim.keymap.set('n', 'glO', vim.lsp.buf.outgoing_calls, createOptions 'Outgoing calls')
    vim.keymap.set('n', 'glI', vim.lsp.buf.incoming_calls, createOptions 'Incoming calls')

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, createOptions 'Hover')
    vim.keymap.set('i', '<c-s>', vim.lsp.buf.signature_help, createOptions 'Signature help')

    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, createOptions 'Previous diagnostic')
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, createOptions 'Next diagnostic')
  end,
  desc = 'Set LSP key mappings',
})
