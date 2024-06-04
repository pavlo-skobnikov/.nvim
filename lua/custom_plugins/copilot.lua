-- Wait a bit get an average completion suggestion 🕰️
return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }
  end,
}
