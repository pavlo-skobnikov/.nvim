return {
    {
        'mfussenegger/nvim-dap', -- Debug Adapter Protocol client
        dependencies = {
            'rcarriga/nvim-dap-ui', -- UI for DAP
            'theHamsta/nvim-dap-virtual-text', -- Virtual Text for DAP
            'nvim-telescope/telescope-dap.nvim', -- UI picker extension for DAP
            'nvim-telescope/telescope.nvim', -- Required for `telescope-dap.nvim`
            'mfussenegger/nvim-dap-python', -- Debug Adapter for Python
            'leoluz/nvim-dap-go', -- Debug Adapter for Go
        },
        config = function()
            -- Redefine DAP signs
            local function setDapSign(name, sign)
                vim.fn.sign_define(name, { text = sign, texthl = '', linehl = '', numhl = '' })
            end

            setDapSign('DapBreakpoint', '🛑')
            setDapSign('DapBreakpointCondition', '🟥')
            setDapSign('DapLogPoint', '📍')
            setDapSign('DapStopped', '🧲')
            setDapSign('DapBreakpointRejected', '❌')

            -- Setup mappings
            local dap = require 'dap'
            local dap_ui = require 'dapui'
            local widgets = require 'dap.ui.widgets'
            local dap_virt = require 'nvim-dap-virtual-text'
            local tele = require 'telescope'

            RegisterWK({
                name = 'dap',
                D = { dap_ui.toggle, 'DAP UI' }, -- General mappings
                O = { dap.repl.open, 'Open REPL' },
                C = { dap.continue, 'Continue' },
                R = { dap.run_last, 'Run last' },
                n = { dap.step_over, 'Step Next' }, -- Step mappings
                i = { dap.step_into, 'Step Into' },
                o = { dap.step_out, 'Step Out' },
                b = { dap.toggle_breakpoint, 'Toggle breakpoint' }, -- Breakpoint mappings
                c = {
                    function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
                    'Toggle conditional breakpoint',
                },
                l = {
                    function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
                    'Toggle log point',
                },
                f = {
                    name = 'find',
                    c = { tele.extensions.dap.commands, 'Commands' },
                    g = { tele.extensions.dap.configurations, 'Configurations' },
                    b = { tele.extensions.dap.list_breakpoints, 'Breakpoints' },
                    v = { tele.extensions.dap.variables, 'Variables' },
                    f = { tele.extensions.dap.frames, 'Frames' },
                },
            }, { prefix = '<leader>d' })

            RegisterWK({
                name = 'widgets',
                h = { widgets.hover, 'Hover' },
                p = { widgets.preview, 'Preview' },
                f = { function() widgets.centered_float(widgets.frames) end, 'Frames' },
                s = { function() widgets.centered_float(widgets.scopes) end, 'Scopes' },
            }, { mode = { 'n', 'v' }, prefix = '<leader>dw' })

            -- Register DAP listeners for automatic opening/closing of DAP UI
            dap.listeners.after.event_initialized['dapui_config'] = dap_ui.open
            dap.listeners.before.event_terminated['dapui_config'] = dap_ui.close
            dap.listeners.before.event_exited['dapui_config'] = dap_ui.close

            -- Setup extension plugins for DAP
            dap_ui.setup()
            dap_virt.setup()
            tele.load_extension 'dap'
        end,
    },
    {
        'Olical/conjure', -- Interactive environment for evaluating code within a running program
        lazy = true,
        ft = { 'clojure', 'fennel', 'lisp', 'scheme' },
        -- Asynchronous build and test dispatcher && Easy commands for Clojure
        dependencies = { 'tpope/vim-dispatch', 'clojure-vim/vim-jack-in', 'folke/which-key.nvim' },
        config = function()
            RegisterWK({
                c = 'connect',
                e = { name = 'evaluate', c = 'comment' },
                g = 'get',
                l = 'log',
                r = 'run',
                s = 'sessions',
                v = 'variables',
                t = 'test',
            }, { prefix = '<LOCALLEADER>' })
        end,
    },
}
