local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

-- Setup lspkind.
lspkind.init()

-- Setup cmp.
local cmp_mappping_override = {
  ['<C-y>'] = cmp.mapping(function(fallback)
    -- This little snippet will confirm or, if no entry is selected, will confirm the first item.
    if cmp.visible() then
      local entry = cmp.get_selected_entry()
      if not entry then cmp.select_next_item { behavior = cmp.SelectBehavior.Select } end
      cmp.confirm()
    else
      fallback()
    end
  end, { 'i', 's', 'c' }),
}

cmp.setup {
  -- Set source priority for appearing in completion prompts.
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'buffer', keyword_length = 4 },
  },

  -- Set up key mappings for completion.
  mapping = cmp.mapping.preset.insert(cmp_mappping_override),

  -- Enable luasnip to handle snippet expansion for nvim-cmp.
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },

  -- Set up cmp-dap integration.
  enabled = function()
    return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
  end,
}

-- Context-aware completion sources setup
cmp.setup.cmdline(
  { '/', '?' },
  { mapping = cmp.mapping.preset.cmdline(cmp_mappping_override), sources = { { name = 'buffer' } } }
)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(cmp_mappping_override),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})
cmp.setup.filetype(
  { 'dap-repl', 'dapui_watches', 'dapui_hover' },
  { mapping = cmp.mapping.preset.insert(cmp_mappping_override), sources = { { name = 'dap' } } }
)
cmp.setup.filetype('gitcommit', {
  mapping = cmp.mapping.preset.insert(cmp_mappping_override),
  sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } }),
})

-- Set up luasnip.
luasnip.config.set_config {
  history = false,
  updateevents = 'TextChanged,TextChangedI',
}

-- Snippet traversal mappings.
vim.keymap.set({ 'i' }, '<C-k>', function() luasnip.expand() end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-l>', function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-h>', function() luasnip.jump(-1) end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-e>', function()
  if luasnip.choice_active() then luasnip.change_choice(1) end
end, { silent = true })
