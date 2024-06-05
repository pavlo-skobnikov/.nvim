-- [[ Options ]]

local options = {
  backup = false, -- Creates a backup file.
  clipboard = 'unnamedplus', -- Allows neovim to access the system clipboard.
  cmdheight = 1, -- More space in the neovim command line for displaying messages.
  completeopt = {
    'menu',
    'menuone',
    'noselect',
    'noinsert',
  }, -- A comma separated list of options for Insert mode completion.
  conceallevel = 0, -- Hide some stuff in markdown.
  colorcolumn = '100', -- Visual marker for column width.
  fileencoding = 'utf-8', -- The encoding written to a file.
  hlsearch = true, -- Highlight all matches on previous search pattern.
  ignorecase = true, -- Ignore case in search patterns.
  mouse = 'a', -- Allow the mouse to be used in neovim.
  pumheight = 10, -- Pop up menu height.
  showmode = false, -- We don't need to see things like -- INSERT -- Anymore.
  showtabline = 1, -- Show tabs only when there are more than one.
  smartcase = true, -- Smart case.
  smartindent = true, -- Make indenting smarter again.
  splitbelow = true, -- Force all horizontal splits to go below current window.
  splitright = true, -- Force all vertical splits to go to the right of current window.
  swapfile = false, -- Creates a swapfile.
  termguicolors = true, -- Set term gui colors (most terminals support this).
  timeout = true, -- Enable timeout.
  timeoutlen = 200, -- Time to wait for a mapped sequence to complete (in milliseconds).
  undofile = true, -- Enable persistent undo.
  updatetime = 300, -- Faster completion (4000ms default).
  writebackup = false, -- If a file is being edited by another program (or was written to file.
  --  while editing with another program), it is not allowed to be edited.
  expandtab = true, -- Convert tabs to spaces.
  shiftwidth = 4, -- How much to (de-)indent when using `<` && `>` operators.
  tabstop = 4, -- Insert 4 spaces for a tab.
  cursorline = true, -- Highlight the current line.
  number = true, -- Set numbered lines.
  relativenumber = true, -- Set relative numbered lines.
  numberwidth = 4, -- Set number column width to 4.
  signcolumn = 'yes', -- Always show the sign column, otherwise it would shift the text each time.
  wrap = false, -- Don't soft-wrap lines.
  linebreak = true, -- Companion to wrap, don't split words.
  list = true, -- Enable displaying hidden characters.
  listchars = {
    tab = '>·',
    leadmultispace = '⎸   ',
    extends = '▸',
    precedes = '◂',
    trail = '·',
  }, -- Show hidden characters.
  scrolloff = 8, -- Minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8, -- Minimal number of screen columns either side of cursor if wrap is `false`.
  guifont = 'monospace:h17', -- The font used in graphical neovim applications.
  whichwrap = 'bs<>[]hl', -- Which "horizontal" keys are allowed to travel to prev/next line.
  wildignorecase = true, -- When set case is ignored when completing file names and directories.
  wildmode = 'list:longest,full', -- Bash-like completion in command line.
  shortmess = 'filnxtToOFc', -- Flags for short messages.
  -- Set up folds.
  foldcolumn = '1', -- Set fold column width to 1.
  foldlevel = 20, -- Higher number => more folds open.
  foldmethod = 'expr', -- Set fold method to expression.
  foldexpr = 'nvim_treesitter#foldexpr()', -- Set fold expression to treesitter.
}

-- Set vim options.
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- [[ Commands ]]

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

-- [[ Autocommands ]]

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
    local function create_options(description) return { buffer = e.buf, desc = description } end

    vim.keymap.set('n', 'crr', vim.lsp.buf.code_action, create_options 'Refactor action')
    vim.keymap.set('n', 'crl', vim.lsp.codelens.run, create_options 'Code lens')
    vim.keymap.set('n', 'crn', vim.lsp.buf.rename, create_options 'Rename')
    vim.keymap.set('n', 'crh', vim.lsp.buf.document_highlight, create_options 'Highlight')
    vim.keymap.set('n', 'crf', vim.diagnostic.open_float, create_options 'Float diagnostics')

    vim.keymap.set('n', 'gr', builtin.lsp_references, create_options 'References')
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, create_options 'Go to definition')
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, create_options 'Go to declaration')
    vim.keymap.set('n', 'glt', builtin.lsp_type_definitions, create_options 'Go to type definition')
    vim.keymap.set('n', 'gli', builtin.lsp_implementations, create_options 'Go to implementation')

    vim.keymap.set('n', 'gldw', builtin.diagnostics, create_options 'Workspace diagnostics')
    vim.keymap.set('n', 'gldb', function() builtin.diagnostics { bufnr = 0 } end, create_options 'Buffer diagnostics')

    vim.keymap.set('n', 'glsd', builtin.lsp_document_symbols, create_options 'Document symbols')
    vim.keymap.set('n', 'glsw', builtin.lsp_workspace_symbols, create_options 'Workspace symbols')
    vim.keymap.set('n', 'glss', builtin.lsp_dynamic_workspace_symbols, create_options 'Dynamic workspace symbols')
    vim.keymap.set('n', 'glst', builtin.treesitter, create_options 'Treesitter symbols')

    vim.keymap.set('n', 'glco', builtin.lsp_outgoing_calls, create_options 'Outgoing calls')
    vim.keymap.set('n', 'glci', builtin.lsp_incoming_calls, create_options 'Incoming calls')

    vim.keymap.set({ 'n', 'v' }, 'K', vim.lsp.buf.hover, create_options 'Hover')
    vim.keymap.set({ 'n', 'v', 'i' }, '<C-S-k>', vim.lsp.buf.signature_help, create_options 'Signature help')

    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, create_options 'Previous diagnostic')
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, create_options 'Next diagnostic')
  end,
  desc = 'Set LSP key mappings',
})

-- [[ Basig Mappings ]]

vim.keymap.set('n', '<ESC>', function()
  vim.cmd ':noh'
  vim.cmd ':call clearmatches()'
  vim.lsp.buf.clear_references()
end, { desc = 'Escape and clear highlights' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center screen' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center screen' })

-- Trim patches of whitespace to a single space.
vim.keymap.set('n', 'd<SPACE>', 'f<SPACE>diwi<SPACE><ESC>', { desc = 'Delete whitespaces' })
vim.keymap.set('n', 'c<SPACE>', 'f<SPACE>diwi<SPACE>', { desc = 'Change whitespaces' })

-- Highlight word under cursor.
vim.keymap.set(
  'n',
  'g*',
  function() vim.fn.matchadd('Search', vim.fn.expand '<cword>') end,
  { desc = 'Highlight word under cursor' }
)

-- Actions without copying into the default register.
vim.keymap.set('v', '<LEADER>D', '"_d', { desc = 'Delete without copying' })
vim.keymap.set('v', '<LEADER>P', '"_dP', { desc = 'Paste without copying' })
