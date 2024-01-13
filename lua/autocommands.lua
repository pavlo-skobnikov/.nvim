vim.api.nvim_create_autocmd('FocusGained', {
    group = vim.api.nvim_create_augroup('CheckFileForExternalChanges', { clear = true }),
    pattern = { '*' },
    callback = function() vim.cmd 'checktime' end, -- Checks if file was changed while outside of NeoVim
    desc = "Update the file's buffer when there are changes to the file on disk",
})

local function getGitBranchName()
    local result = vim.fn.system 'git branch --show-current'

    if string.match(result, 'fatal') then return 'NO-GIT' end

    return vim.fn.trim(result)
end

local function setStatusLine()
    vim.opt.statusline = '%f  %r%m%=%y  (' .. getGitBranchName() .. ')    %l,%c    %P'
end

vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('UpdateCurrentGitBranch', { clear = true }),
    pattern = { '*' },
    callback = function()
        -- Gets the current git branch and sets it to the buffer variable
        vim.cmd [[let b:git_branch = trim(system('git branch --show-current'))]]
        -- Set the statusline only once
        setStatusLine()
    end,
    desc = "Update the file's buffer when there are changes to the file on disk",
})
