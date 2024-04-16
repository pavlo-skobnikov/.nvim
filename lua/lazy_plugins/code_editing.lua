return {
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true }, -- Auto-pairing of brackets, quotes, etc.
  { 'numToStr/Comment.nvim', event = 'InsertEnter', config = true }, -- Selection- & motion-based commenting
  { 'tpope/vim-repeat' }, -- Extra dot-repeating functionality
  {
    'tpope/vim-surround', -- Actions on surrounding characters (e.g. brackets & quotes)
    event = 'InsertEnter',
    config = function()
      U.register_keys {
        cs = { name = 'surround' },
        ys = { name = 'surround' },
        ds = { name = 'surround' },
      }
    end,
  },
  {
    'julienvincent/nvim-paredit', -- Paredit for Neovim
    event = 'InsertEnter *.clj',
    config = function()
      local paredit = require 'nvim-paredit'

      local pe_cursor = paredit.cursor
      local pe_wrap = paredit.wrap
      local pe_unwrap = paredit.unwrap
      local pe_api = paredit.api

      -- Create a function to place the cursor in insert mode at the given position with optional form wrapping
      local function get_place_cursor_fn(placement, prefix, suffix)
        prefix = prefix or ''
        suffix = suffix or ''

        return function()
          pe_cursor.place_cursor(
            pe_wrap.wrap_enclosing_form_under_cursor(prefix, suffix),
            { placement = placement, mode = 'insert' }
          )
        end
      end

      local move_modes = { 'n', 'x', 'o', 'v' }
      local obj_modes = { 'o', 'v' }

      local keymaps = {
        ['dsf'] = { pe_unwrap.unwrap_form_under_cursor, 'Splice form' },

        ['<localleader>o'] = { pe_api.raise_form, 'Raise form' },
        ['<localleader>O'] = { pe_api.raise_element, 'Raise element' },

        ['<localleader>i'] = { get_place_cursor_fn 'inner_start', 'Insert in form' },
        ['<localleader>I'] = { get_place_cursor_fn 'left_edge', 'Insert in form' },
        ['<localleader>a'] = { get_place_cursor_fn 'inner_end', 'Append in form' },
        ['<localleader>A'] = { get_place_cursor_fn 'right_edge', 'Append in form' },

        ['>)'] = { pe_api.slurp_forwards, 'Slurp forwards' },
        ['<('] = { pe_api.slurp_backwards, 'Slurp backwards' },
        ['>('] = { pe_api.barf_backwards, 'Barf backwards' },
        ['<)'] = { pe_api.barf_forwards, 'Barf forwards' },

        ['>e'] = { pe_api.drag_element_forwards, 'Drag element right' },
        ['<e'] = { pe_api.drag_element_backwards, 'Drag element left' },
        ['>f'] = { pe_api.drag_form_forwards, 'Drag form right' },
        ['<f'] = { pe_api.drag_form_backwards, 'Drag form left' },

        ['cse('] = { get_place_cursor_fn('inner_start', '( ', ')'), 'Wrap (element) & insert head' },
        ['cse)'] = { get_place_cursor_fn('inner_end', '(', ')'), 'Wrap (element) & insert tail' },
        ['cse['] = { get_place_cursor_fn('inner_start', '[ ', ']'), 'Wrap [element] & insert head' },
        ['cse]'] = { get_place_cursor_fn('inner_end', '[', ']'), 'Wrap [element] & insert tail' },
        ['cse{'] = { get_place_cursor_fn('inner_start', '{ ', '}'), 'Wrap {element} & insert head' },
        ['cse}'] = { get_place_cursor_fn('inner_end', '{', '}'), 'Wrap {element} & insert tail' },

        ['csf('] = { get_place_cursor_fn('inner_start', '( ', ')'), 'Wrap (element) & insert head' },
        ['csf)'] = { get_place_cursor_fn('inner_end', '(', ')'), 'Wrap (element) & insert tail' },
        ['csf['] = { get_place_cursor_fn('inner_start', '[ ', ']'), 'Wrap [element] & insert head' },
        ['csf]'] = { get_place_cursor_fn('inner_end', '[', ']'), 'Wrap [element] & insert tail' },
        ['csf{'] = { get_place_cursor_fn('inner_start', '{ ', '}'), 'Wrap {element} & insert head' },
        ['csf}'] = { get_place_cursor_fn('inner_end', '{', '}'), 'Wrap {element} & insert tail' },

        ['E'] = { pe_api.move_to_next_element_tail, 'Jump to next element tail', mode = move_modes },
        ['W'] = { pe_api.move_to_next_element_head, 'Jump to next element head', mode = move_modes },
        ['B'] = { pe_api.move_to_prev_element_head, 'Jump to previous element head', mode = move_modes },
        ['gE'] = { pe_api.move_to_prev_element_tail, 'Jump to previous element tail', mode = move_modes },

        ['('] = { pe_api.move_to_parent_form_start, "Jump to parent form's head", mode = move_modes },
        [')'] = { pe_api.move_to_parent_form_end, "Jump to parent form's tail", mode = move_modes },

        ['af'] = { pe_api.select_around_form, 'around form', mode = obj_modes },
        ['if'] = { pe_api.select_in_form, 'inner form', mode = obj_modes },
        ['aF'] = { pe_api.select_around_top_level_form, 'around top-level form', mode = obj_modes },
        ['iF'] = { pe_api.select_in_top_level_form, 'inner top-level form', mode = obj_modes },
        ['ae'] = { pe_api.select_element, 'an element', mode = obj_modes },
        ['ie'] = { pe_api.select_element, 'inner element', mode = obj_modes },
      }

      paredit.setup {
        use_default_keys = true,
        filetypes = { 'clojure' },
        cursor_behaviour = 'auto',
        indent = { enabled = true, indentor = require('nvim-paredit.indentation.native').indentor },
        keys = keymaps,
      }
    end,
  },
}
