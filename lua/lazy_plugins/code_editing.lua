return {
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true }, -- Auto-pairing of brackets, quotes, etc.
  { 'numToStr/Comment.nvim', event = 'InsertEnter', config = true }, -- Selection- & motion-based commenting
  { 'tpope/vim-repeat' }, -- Extra dot-repeating functionality
  { 'tpope/vim-surround', event = 'InsertEnter' }, -- Actions on surrounding characters (e.g. brackets & quotes)
  {
    'julienvincent/nvim-paredit', -- Paredit for Neovim
    event = 'InsertEnter *.clj',
    config = function()
      local paredit = require 'nvim-paredit'

      -- Create a function to place the cursor in insert mode at the given position with optional form wrapping
      local function get_place_cursor_fn(placement, prefix, suffix)
        prefix = prefix or ''
        suffix = suffix or ''

        return function()
          paredit.cursor.place_cursor(
            paredit.wrap.wrap_enclosing_form_under_cursor(prefix, suffix),
            { placement = placement, mode = 'insert' }
          )
        end
      end

      local move_modes = { 'n', 'x', 'o', 'v' }
      local obj_modes = { 'o', 'v' }

      local keymaps = {
        ['dsf'] = { paredit.unwrap.unwrap_form_under_cursor, 'Splice form' },

        ['<localleader>o'] = { paredit.api.raise_form, 'Raise form' },
        ['<localleader>O'] = { paredit.api.raise_element, 'Raise element' },

        ['<localleader>i'] = { get_place_cursor_fn 'inner_start', 'Insert in form' },
        ['<localleader>I'] = { get_place_cursor_fn 'left_edge', 'Insert in form' },
        ['<localleader>a'] = { get_place_cursor_fn 'inner_end', 'Append in form' },
        ['<localleader>A'] = { get_place_cursor_fn 'right_edge', 'Append in form' },

        ['>)'] = { paredit.api.slurp_forwards, 'Slurp forwards' },
        ['<('] = { paredit.api.slurp_backwards, 'Slurp backwards' },
        ['>('] = { paredit.api.barf_backwards, 'Barf backwards' },
        ['<)'] = { paredit.api.barf_forwards, 'Barf forwards' },

        ['>e'] = { paredit.api.drag_element_forwards, 'Drag element right' },
        ['<e'] = { paredit.api.drag_element_backwards, 'Drag element left' },
        ['>f'] = { paredit.api.drag_form_forwards, 'Drag form right' },
        ['<f'] = { paredit.api.drag_form_backwards, 'Drag form left' },

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

        ['E'] = { paredit.api.move_to_next_element_tail, 'Jump to next element tail', mode = move_modes },
        ['W'] = { paredit.api.move_to_next_element_head, 'Jump to next element head', mode = move_modes },
        ['B'] = { paredit.api.move_to_prev_element_head, 'Jump to previous element head', mode = move_modes },
        ['gE'] = { paredit.api.move_to_prev_element_tail, 'Jump to previous element tail', mode = move_modes },

        ['('] = { paredit.api.move_to_parent_form_start, "Jump to parent form's head", mode = move_modes },
        [')'] = { paredit.api.move_to_parent_form_end, "Jump to parent form's tail", mode = move_modes },

        ['af'] = { paredit.api.select_around_form, 'around form', mode = obj_modes },
        ['if'] = { paredit.api.select_in_form, 'inner form', mode = obj_modes },
        ['aF'] = { paredit.api.select_around_top_level_form, 'around top-level form', mode = obj_modes },
        ['iF'] = { paredit.api.select_in_top_level_form, 'inner top-level form', mode = obj_modes },
        ['ae'] = { paredit.api.select_element, 'an element', mode = obj_modes },
        ['ie'] = { paredit.api.select_element, 'inner element', mode = obj_modes },
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
