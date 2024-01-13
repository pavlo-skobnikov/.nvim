local function getFtFmt(ft, formatter) return require('formatter.filetypes.' .. ft)[formatter] end
local function getShFmt() return getFtFmt('sh', 'shfmt') end
local function getPrettier() return require 'formatter.defaults.prettier' end

return {
    'mhartington/formatter.nvim', -- Easy formatter setup goodness
    dependencies = { 'williamboman/mason.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
        require('formatter').setup {
            logging = true,
            log_level = vim.log.levels.WARN,

            filetype = {
                c = { getFtFmt('c', 'clangformat') },
                zig = { getFtFmt('zig', 'zigfmt') },
                rust = { getFtFmt('rust', 'rustfmt') },
                lua = { getFtFmt('lua', 'stylua') },
                python = { getFtFmt('python', 'black') },
                go = { getFtFmt('go', 'goimports') },
                java = {
                    function()
                        return {
                            exe = 'google-java-format',
                            args = {
                                '-a',
                                vim.api.nvim_buf_get_name(0),
                            },
                            stdin = true,
                        }
                    end,
                },
                clojure = {
                    function()
                        return {
                            exe = 'cljfmt',
                            args = {
                                'fix',
                                vim.api.nvim_buf_get_name(0),
                            },
                            stdin = false,
                        }
                    end,
                },
                kotlin = { getFtFmt('kotlin', 'ktlint') },
                javascript = { getPrettier() },
                typescript = { getPrettier() },
                sh = { getShFmt() },
                bash = { getShFmt() },
                zsh = { getShFmt() },
                markdown = { getPrettier() },
                sql = { getPrettier() },
                yaml = { getPrettier() },
                json = { getPrettier() },
                ['*'] = { getFtFmt('any', 'remove_trailing_whitespace') },
            },
        }

        RegisterWK({ ['='] = { ':Format<CR>', 'Format' } }, { prefix = '<LEADER>' })
    end,
}
