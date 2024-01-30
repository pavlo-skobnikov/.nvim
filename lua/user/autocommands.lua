vim.api.nvim_create_autocmd('FocusGained', {
   group = vim.api.nvim_create_augroup('CheckFileForExternalChanges', { clear = true }),
   pattern = { '*' },
   callback = function() vim.cmd('checktime') end, -- Checks if file was changed while outside of NeoVim
   desc = "Update the file's buffer when there are changes to the file on disk",
})

local function get_git_branch_name()
   local result = vim.fn.system('git branch --show-current')

   if string.match(result, 'fatal') then return 'NO-GIT' end

   return vim.fn.trim(result)
end

local function set_status_line()
   vim.opt.statusline = '%f  %r%m%=%y  (' .. get_git_branch_name() .. ')    %l,%c    %P'
end

vim.api.nvim_create_autocmd('BufEnter', {
   group = vim.api.nvim_create_augroup('UpdateCurrentGitBranch', { clear = true }),
   pattern = { '*' },
   callback = function() set_status_line() end,
   desc = "Update the file's buffer when there are changes to the file on disk",
})

vim.api.nvim_create_autocmd('FileType', {
   group = vim.api.nvim_create_augroup('SetTabTo2Spaces', { clear = true }),
   pattern = { 'scala', 'sbt' },
   callback = function() PG.set_tab_spaces(2) end,
   desc = 'Set Tab to 2 spaces',
})

vim.api.nvim_create_autocmd('FileType', {
   group = vim.api.nvim_create_augroup('SetTabTo3Spaces', { clear = true }),
   pattern = { 'lua' },
   callback = function() PG.set_tab_spaces(3) end,
   desc = 'Set Tab to 3 spaces',
})
