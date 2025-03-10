return {
  surrounds = {
    y = {
      add = function()
        local user_input = require('nvim-surround.config').get_input('Enter type: ')
        if user_input then
          local delims = type_delims[vim.bo.filetype]
          if vim.bo.filetype == 'go' then
            delims = { '[', ']' }
          else
            delims = { '<', '>' }
          end
          return { { user_input .. delims[1] }, { delims[2] } }
        end
      end,
      delete = function()
        local shared = require("nvim-treesitter.textobjects.shared")
        local _, outer_textobject = shared.textobject_at_point('@type.outer', 'textobjects', nil, nil,
          { lookahead = false, lookbehind = false })
        if outer_textobject == nil then
          return nil
        end
        local _, inner_textobject = shared.textobject_at_point('@type.inner', 'textobjects', nil, nil,
          { lookahead = false, lookbehind = false })
        if inner_textobject == nil then
          return nil
        end
        return {
          left = {
            first_pos = { outer_textobject[1] + 1, outer_textobject[2] + 1 },
            last_pos = { inner_textobject[1] + 1, inner_textobject[2] + 1 },
          },
          right = {
            first_pos = { inner_textobject[3] + 1, inner_textobject[4] },
            last_pos = { outer_textobject[3] + 1, outer_textobject[4] },
          },
        }
      end,
    }
  }
}
