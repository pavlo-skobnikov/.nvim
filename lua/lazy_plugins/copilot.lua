return {
  'github/copilot.vim', -- AI-powered code completion
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }
  end,
}
