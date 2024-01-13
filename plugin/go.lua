local goCmds = vim.api.nvim_create_augroup('go_cmds', { clear = true })

local function getDapGo()
    return require 'dap-go'
end

local function setupDapGo()
    getDapGo().setup()
end

local function setDapMappings()
    local dapGo = getDapGo()

    RegisterWK({
        name = 'test',
        n = { dapGo.debug_test, 'Nearest' },
        l = { dapGo.debug_last_test, 'Last' },
    }, { prefix = '<LEADER>dt' })
end

local function setupGo()
    setupDapGo()
    setDapMappings()
end

vim.api.nvim_create_autocmd('FileType', {
    group = goCmds,
    pattern = { 'go' },
    desc = 'Setup Go',
    callback = setupGo,
})
