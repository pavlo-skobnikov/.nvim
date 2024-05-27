local function get_ft_formatter(ft, formatter) return { require('formatter.filetypes.' .. ft)[formatter] } end
local function get_buffer_fname() return vim.api.nvim_buf_get_name(0) end

local prettier_formatter = { require 'formatter.defaults.prettier' }

require('formatter.init').setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    c = get_ft_formatter('c', 'clangformat'),
    lua = get_ft_formatter('lua', 'stylua'),
    python = get_ft_formatter('python', 'black'),
    go = get_ft_formatter('go', 'goimports'),
    java = { function() return { exe = 'google-java-format', args = { '-a', get_buffer_fname() }, stdin = true } end },
    kotlin = get_ft_formatter('kotlin', 'ktlint'),
    scala = { function() pcall(vim.lsp.buf.format) end },
    javascript = prettier_formatter,
    typescript = prettier_formatter,
    sh = get_ft_formatter('sh', 'shfmt'),
    bash = get_ft_formatter('sh', 'shfmt'),
    zsh = get_ft_formatter('sh', 'shfmt'),
    markdown = prettier_formatter,
    sql = prettier_formatter,
    yaml = prettier_formatter,
    json = prettier_formatter,
    ['*'] = get_ft_formatter('any', 'remove_trailing_whitespace'),
  },
}

Set({ 'n', 'v' }, '<M-=>', '<CMD>FormatWrite<CR>', { desc = 'Format & write' })
