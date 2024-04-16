return {
  'github/copilot.vim', -- AI-powered code completion
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_filetypes = { ['TelescopePrompt'] = false }

    U.register_keys({
      ['<c-s-y>'] = { 'copilot#Accept("\\<CR>")', 'Accept Copilot suggestion' },
    }, { silent = true, expr = true, script = true, replace_keycodes = false, mode = 'i' })
  end,
}
