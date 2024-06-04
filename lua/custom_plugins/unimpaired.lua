-- Useful & comfy mappings for basic Vim commands via '[' and ']', as well as toggling functionality 🐚
return {
  'Tummetott/unimpaired.nvim',
  event = 'BufEnter',
  opts = function()
    local function get_mapping(mapping, description)
      return { mapping = mapping, description = description, dot_repeat = true }
    end

    local function get_leader_mapping(mapping, description) return get_mapping(Leader .. mapping, description) end

    return {
      default_keymaps = false,
      keymaps = {
        cprevious = get_mapping('[q', 'Previous [count] qflist'),
        cnext = get_mapping(']q', 'Next [count] qflist'),
        toggle_cursorline = get_leader_mapping('tc', 'cursorline'),
        toggle_hlsearch = get_leader_mapping('th', 'hlsearch'),
        toggle_ignorecase = get_leader_mapping('ti', 'ignorecase'),
        toggle_list = get_leader_mapping('tl', 'Invisible characters (listchars)'),
        toggle_number = get_leader_mapping('tn', 'Line numbers'),
        toggle_relativenumber = get_leader_mapping('tr', 'Relative numbers'),
        toggle_spell = get_leader_mapping('ts', 'Spell check'),
        toggle_background = get_leader_mapping('tb', 'background'),
        toggle_colorcolumn = get_leader_mapping('tt', 'colorcolumn'),
        toggle_cursorcolumn = get_leader_mapping('tu', 'cursorcolumn'),
        toggle_virtualedit = get_leader_mapping('tv', 'virtualedit'),
        toggle_wrap = get_leader_mapping('tw', 'Line wrapping'),
        toggle_cursorcross = get_leader_mapping('tx', 'cursorcross'),
      },
    }
  end,
}
