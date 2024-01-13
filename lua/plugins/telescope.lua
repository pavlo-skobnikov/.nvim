local function getTelescope() return require 'telescope' end
local function loadTelescopeExtension(extension) return getTelescope().load_extension(extension) end

return {
    {
        'nvim-telescope/telescope.nvim', -- An incredibly extendable fuzzy finder over lists
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            getTelescope().setup {
                defaults = {
                    -- Default Telescope configurations to be applied for all searches
                    dynamic_preview_title = true,
                    path_display = { 'tail' },
                    layout_strategy = 'vertical',
                    layout_config = { vertical = { mirror = false } },
                    pickers = { lsp_incoming_calls = { path_display = 'tail' } },
                },
            }

            -- Telescope main commands
            local bi = require 'telescope.builtin'

            RegisterWK({
                b = { bi.buffers, 'Buffers' },
                c = { bi.commands, 'Command && run' },
                d = { bi.command_history, 'In command history' },
                e = { bi.spell_suggest, 'Spelling suggestion && apply' },
                f = {
                    function()
                        bi.find_files {
                            find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
                        }
                    end,
                    'All files',
                },
                g = { bi.live_grep, 'grep search' },
                h = { bi.help_tags, 'Doc help' },
                k = { bi.keymaps, 'Keymaps' },
                l = { bi.loclist, 'In loclist' },
                m = { bi.marks, 'Marks' },
                r = { bi.resume, 'Resume previous search' },
                s = { bi.search_history, 'in search history' },
                q = { bi.quickfix, 'In qflist' },
                t = { bi.tags, 'Tags' },
                ['"'] = { bi.registers, 'In registers (")' },
            }, { prefix = '<leader>f' })
        end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim', -- UI picker extension for Telescope
        dependencies = 'nvim-telescope/telescope.nvim',
        config = function() loadTelescopeExtension 'ui-select' end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim', -- Blazingly-fast C port of FZF for Telescope
        dependencies = 'nvim-telescope/telescope.nvim',
        build = 'make',
        config = function() loadTelescopeExtension 'fzf' end,
    },
}
