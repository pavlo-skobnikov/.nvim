local M = {}

function M.onAttach(client, bufnr)
    local tb = require 'telescope.builtin'

    local opts = { silent = true, buffer = bufnr, remap = false }
    local function createOptsWith(values)
        local copy = vim.deepcopy(opts)

        for k, v in pairs(values) do
            copy[k] = v
        end

        return copy
    end

    local function addMappingsForPresentCapabilities(whichKeyMappingTable, capabilitiesAndMappings)
        local mergeTable = {}

        for key, value in pairs(whichKeyMappingTable) do
            mergeTable[key] = value
        end

        for capability, mappings in pairs(capabilitiesAndMappings) do
            if client.server_capabilities[capability] then
                for key, value in pairs(mappings) do
                    mergeTable[key] = value
                end
            end
        end

        return mergeTable
    end

    -- Basic info actions
    RegisterWK({ K = { vim.lsp.buf.hover, 'Show kind' } }, createOptsWith { mode = { 'n', 'v' } })
    RegisterWK({
        ['<C-S-k>'] = { vim.lsp.buf.signature_help, 'Show function parameter info' },
    }, createOptsWith { mode = { 'n', 'i' } })

    -- Next/previous diagnostic
    local repeatMove = require 'nvim-treesitter.textobjects.repeatable_move'
    local nextDiagnosticFunc, prevDiagnosticFunc =
        repeatMove.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)

    RegisterWK({
        [']d'] = { nextDiagnosticFunc, 'Next diagnostic' },
        ['[d'] = { prevDiagnosticFunc, 'Previous diagnostic' },
    }, opts)

    -- Go to LSP capability actions
    local goToLspActionMappings = addMappingsForPresentCapabilities({}, {
        ['definitionProvider'] = { d = { vim.lsp.buf.definition, 'Go to definition' } },
        ['declarationProvider'] = { D = { vim.lsp.buf.declaration, 'Go to declaration' } },
        ['implementationProvider'] = { I = { vim.lsp.buf.implementation, 'Go to implementation' } },
        ['callHierarchyProvider'] = {
            o = { vim.lsp.buf.outgoing_calls, 'Search outgoing calls' },
            i = { vim.lsp.buf.incoming_calls, 'Search incoming calls' },
        },
        ['typeDefinitionProvider'] = {
            t = { vim.lsp.buf.type_definition, 'Go to type definition' },
        },
        ['referencesProvider'] = { r = { vim.lsp.buf.references, 'Search references' } },
    })

    RegisterWK(goToLspActionMappings, createOptsWith { prefix = 'g' })

    -- 'Refactor' actions
    local function getDiagnosticsFunc(severity)
        return function() tb.diagnostics { severity = vim.diagnostic.severity[severity] } end
    end

    local refactorActionMappings = addMappingsForPresentCapabilities({
        name = 'refactor',
        f = { vim.diagnostic.open_float, 'Diagnostics float' },
        l = { vim.lsp.codelens.run, 'Code lens' },
        s = {
            name = 'show',
            w = { getDiagnosticsFunc 'WARN', 'Warnings' },
            e = { getDiagnosticsFunc 'ERROR', 'Errors' },
        },
    }, {
        ['codeActionProvider'] = { a = { vim.lsp.buf.code_action, 'Actions' } },
        ['renameProvider'] = { n = { vim.lsp.buf.rename, 'Rename' } },
        ['documentHighlightProvider'] = {
            h = { vim.lsp.buf.document_highlight, 'Highlight symbol' },
        },
        ['documentSymbolProvider'] = { d = { tb.lsp_document_symbols, 'Search document symbols' } },
        ['workspaceSymbolProvider'] = {
            w = { tb.lsp_workspace_symbols, 'Search workspace symbols' },
        },
    })

    RegisterWK(refactorActionMappings, createOptsWith { prefix = '<LEADER>r' })
end

return M
