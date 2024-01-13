local python_cmds = vim.api.nvim_create_augroup('python_cmds', { clear = true })

local function getDapPy()
    return require 'dap-python'
end

local function setupDapPy()
    local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path()
        .. '/venv/bin/python'

    getDapPy().setup(debugpy_path)
end

local function setKeyMappings()
    local dapPy = getDapPy()

    RegisterWK({
        name = 'test',
        c = { dapPy.test_class, 'Class' },
        n = { dapPy.test_method, 'Nearest' },
        s = { dapPy.debug_selection, 'Selection' },
    }, { prefix = '<leader>dt' })
end

local function setupPy()
    setupDapPy()
    setKeyMappings()
end

vim.api.nvim_create_autocmd('FileType', {
    group = python_cmds,
    pattern = { 'python' },
    desc = 'Setup Python',
    callback = setupPy,
})
