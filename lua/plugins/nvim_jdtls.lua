---@diagnostic disable: undefined-field, missing-fields

-- Requires the `jdtls` module
local function req_jdtls() return require('jdtls') end

-- Returns the path to a Mason-installed package
local function get_mason_package_path(package_name)
   return require('mason-registry').get_package(package_name):get_install_path()
end

-- Extends a list with another list if the latter is not nil
local function extend_list_optionally(destination_list, optional_list)
   if optional_list then vim.list_extend(destination_list, optional_list) end
end

-- Returns a list of jars for the java-test bundle or nil if it's not present
local function get_test_bundle()
   local java_test_path = get_mason_package_path('java-test')
   local java_test_bundle =
      vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n')

   if java_test_bundle[1] ~= '' then return java_test_bundle end
end

-- Returns a list of jars for the java-debug-adapter bundle or nil if it's not present
local function get_debugger_bundle()
   local debugger_path = get_mason_package_path('java-debug-adapter')
   local debugger_jars =
      vim.fn.glob(debugger_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar')
   local java_debug_bundle = vim.split(debugger_jars, '\n')

   if java_debug_bundle[1] ~= '' then return java_debug_bundle end
end

-- Returns a list of jars for the vscode-java-decompiler bundle or nil if it's not present
local function get_decompiler_bundle()
   local decompiler_path = get_mason_package_path('vscode-java-decompiler')
   local decompiler_jars = vim.fn.glob(decompiler_path .. '/server/*.jar')
   local decompiler_bundle = vim.fn.split(decompiler_jars, '\n')

   if decompiler_bundle[1] ~= '' then return decompiler_bundle end
end

-- Attaches to a running Java debug process
local function attach_to_debugger()
   local dap = require('dap')

   dap.configurations.java = {
      {
         type = 'java',
         request = 'attach',
         name = 'Attach to the process',
         hostName = 'localhost',
         port = '5005',
      },
   }

   dap.continue()
end

-- Calls the jdtls function to setup debugging
local function setup_debugger(bufnr)
   local jdtls = req_jdtls()

   jdtls.setup_dap({ hotcodereplace = 'auto' })
   require('jdtls.dap').setup_dap_main_class_configs()

   PG.reg_wk({
      t = {
         name = 'test',
         c = { jdtls.test_class, 'Class' },
         n = { jdtls.test_nearest_method, 'Nearest' },
      },
      a = { attach_to_debugger, 'Attach' },
   }, { prefix = '<leader>d', buffer = bufnr })
end

-- Calls code lens and sets up an autocmd to refresh it after saving
local function setup_code_lens(bufnr, autocmd_group)
   pcall(vim.lsp.codelens.refresh)

   vim.api.nvim_create_autocmd('BufWritePost', {
      buffer = bufnr,
      group = autocmd_group,
      desc = 'Refresh codelens after saving',
      callback = function() pcall(vim.lsp.codelens.refresh) end,
   })
end

-- Returns the capabilities for the jdtls client
local function get_capabilities()
   req_jdtls().extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

   local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

   return vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      ok_cmp and cmp_lsp.default_capabilities() or {}
   )
end

return {
   'mfussenegger/nvim-jdtls',
   dependencies = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim', 'folke/which-key.nvim' },
   ft = { 'java' },
   config = function()
      local jdtls_group = vim.api.nvim_create_augroup('jdtlsCommands', { clear = true })
      local cache_variables = {}

      local function get_jdtls_paths()
         if cache_variables.paths then return cache_variables.paths end

         local paths = {}

         paths.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

         local jdtls_install_path = get_mason_package_path('jdtls')

         paths.java_agent = jdtls_install_path .. '/lombok.jar'
         paths.launcher_jar =
            vim.fn.glob(jdtls_install_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
         paths.platform_config = jdtls_install_path .. '/config_mac'

         local bundles = {}

         extend_list_optionally(bundles, get_test_bundle())
         extend_list_optionally(bundles, get_debugger_bundle())
         extend_list_optionally(bundles, get_decompiler_bundle())

         paths.bundles = bundles

         ---
         -- Needs overriding if jdtls is started with a different Java version than the project.
         ---
         paths.runtimes = {
            -- Note: the field `name` must be a valid `ExecutionEnvironment`:
            -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            --
            -- Example if `sdkman` is being used.
            -- {
            --   name = 'JavaSE-17',
            --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
            -- },
            -- {
            --   name = 'JavaSE-18',
            --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
            -- },
         }

         cache_variables.paths = paths

         return paths
      end

      local function jdtls_on_attach(client, bufnr)
         setup_debugger(bufnr)
         setup_code_lens(bufnr, jdtls_group)
         PG.shared_on_attach_lsp(client, bufnr)
      end

      local function jdtls_setup()
         local jdtls = req_jdtls()
         local path = get_jdtls_paths()
         local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

         if cache_variables.capabilities == nil then
            cache_variables.capabilities = get_capabilities()
         end

         local cmd = { -- The command that starts the language server
            'java',
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-javaagent:' .. path.java_agent,
            '-Xms1g',
            '--add-modules=ALL-SYSTEM',
            '--add-opens',
            'java.base/java.util=ALL-UNNAMED',
            '--add-opens',
            'java.base/java.lang=ALL-UNNAMED',
            '-jar',
            path.launcher_jar,
            '-configuration',
            path.platform_config,
            '-data',
            data_dir,
         }

         local lsp_settings = {
            java = {
               eclipse = { downloadSources = true },
               configuration = {
                  updateBuildConfiguration = 'interactive',
                  runtimes = path.runtimes,
               },
               maven = { downloadSources = true },
               implementationsCodeLens = { enabled = true },
               referencesCodeLens = { enabled = true },
               references = { includeDecompiledSources = true },
               inlayHints = { parameterNames = { enabled = 'all' } },
               format = { enabled = true },
            },
            signatureHelp = { enabled = true },
            completion = {
               favoriteStaticMembers = {
                  'org.hamcrest.MatcherAssert.assertThat',
                  'org.hamcrest.Matchers.*',
                  'org.hamcrest.CoreMatchers.*',
                  'org.junit.jupiter.api.Assertions.*',
                  'java.util.Objects.requireNonNull',
                  'java.util.Objects.requireNonNullElse',
                  'org.mockito.Mockito.*',
               },
            },
            contentProvider = { preferred = 'fernflower' },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
            sources = {
               organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
               },
            },
            codeGeneration = {
               toString = {
                  template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
               },
               useBlocks = true,
            },
         }

         jdtls.start_or_attach({
            cmd = cmd,
            settings = lsp_settings,
            on_attach = jdtls_on_attach,
            capabilities = cache_variables.capabilities,
            flags = { allow_incremental_sync = true },
            init_options = { bundles = path.bundles },
         })
      end

      vim.api.nvim_create_autocmd('FileType', {
         group = jdtls_group,
         pattern = { 'java' },
         desc = 'Setup JDTLS',
         callback = jdtls_setup,
      })
   end,
}
