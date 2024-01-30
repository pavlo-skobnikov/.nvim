-- Return the formatter package for the given filetype
---@param ft string The required filetype
---@param formatter string The required formatter
local function req_ft_formatter(ft, formatter)
   return require('formatter.filetypes.' .. ft)[formatter]
end

-- Get currently-opened file name
local function get_file_name() return vim.api.nvim_buf_get_name(0) end

-- Specific formatter suppliers
local function get_sh_fmt() return req_ft_formatter('sh', 'shfmt') end
local function get_prettier() return require('formatter.defaults.prettier') end
local function get_java_fmt()
   return { exe = 'google-java-format', args = { '-a', get_file_name() }, stdin = true }
end
local function get_clojure_fmt()
   return { exe = 'cljfmt', args = { 'fix', get_file_name() }, stdin = false }
end
local function run_lsp_formatter() pcall(vim.lsp.buf.format) end

return {
   'mhartington/formatter.nvim', -- Easy formatter setup goodness
   dependencies = { 'williamboman/mason.nvim', 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
   event = 'VeryLazy',
   opts = { logging = true, log_level = vim.log.levels.WARN },
   config = function(_, opts)
      local filetypesAndFormatters = {
         c = { req_ft_formatter('c', 'clangformat') },
         zig = { req_ft_formatter('zig', 'zigfmt') },
         rust = { req_ft_formatter('rust', 'rustfmt') },
         lua = { req_ft_formatter('lua', 'stylua') },
         python = { req_ft_formatter('python', 'black') },
         go = { req_ft_formatter('go', 'goimports') },
         java = { get_java_fmt },
         clojure = { get_clojure_fmt },
         kotlin = { req_ft_formatter('kotlin', 'ktlint') },
         scala = { run_lsp_formatter },
         javascript = { get_prettier() },
         typescript = { get_prettier() },
         sh = { get_sh_fmt() },
         bash = { get_sh_fmt() },
         zsh = { get_sh_fmt() },
         markdown = { get_prettier() },
         sql = { get_prettier() },
         yaml = { get_prettier() },
         json = { get_prettier() },
         ['*'] = { req_ft_formatter('any', 'remove_trailing_whitespace') },
      }

      local extended_opts = vim.tbl_extend('error', opts, { filetype = filetypesAndFormatters })

      require('formatter.init').setup(extended_opts)

      PG.reg_wk({ ['<leader>='] = { ':Format<cr>', 'Format' } })
   end,
}
