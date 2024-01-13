local function getMetals()
    return require 'metals'
end

local function getMetalsMainCfg()
    local metalsCfg = getMetals().bare_config()

    -- Example of settings
    metalsCfg.settings = {
        showImplicitArguments = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
    }

    -- Setting statusBarProvider to true is highly recommend.
    -- If it's set to true, then it's to have a setting to display this in
    -- the statusline or else no messages from metals will be seen. There is more
    -- info in the help docs about this
    -- metals_config.init_options.statusBarProvider = "on"

    -- Setup capabilites for `cmp` snippets
    metalsCfg.capabilities = require('cmp_nvim_lsp').default_capabilities()

    return metalsCfg
end

-- Debug settings if you're using nvim-dap
local function setupDapCfg()
    local dap = require 'dap'

    dap.configurations.scala = {
        {
            type = 'scala',
            request = 'launch',
            name = 'RunOrTest',
            metals = {
                runType = 'runOrTestFile',
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
        },
        {
            type = 'scala',
            request = 'launch',
            name = 'Test Target',
            metals = {
                runType = 'testTarget',
            },
        },
    }
end

local function composeMetalsCfg()
    local metalsCfg = getMetalsMainCfg()
    local metals = getMetals()

    metalsCfg.on_attach = function(client, bufnr)
        RegisterWK({
            w = {
                function()
                    metals.hover_worksheet()
                end,
                'Open worksheet',
            },
        }, { prefix = '<LEADER>r' })

        require('shared').onAttach(client, bufnr)

        setupDapCfg()
        metals.setup_dap()
    end

    return metalsCfg
end

local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    -- NOTE: Java might or might not need to be included. It's needed if
    -- basic Java support in a Scala-Java project is required but it may also conflict
    -- with nvim-jdtls which also works on a java filetype autocmd.
    -- pattern = { 'scala', 'sbt', 'java' },
    pattern = { 'scala', 'sbt' },
    callback = function()
        getMetals().initialize_or_attach(composeMetalsCfg())
    end,
    group = nvim_metals_group,
})
