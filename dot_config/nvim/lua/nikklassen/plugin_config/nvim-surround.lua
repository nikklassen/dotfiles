return {
  surrounds = {
    y = {
      add = function()
        local user_input = require('nvim-surround.config').get_input('Enter type: ')
        if user_input then
          local delims
          if vim.bo.filetype == 'go' then
            delims = { '[', ']' }
          else
            delims = { '<', '>' }
          end
          return { { user_input .. delims[1] }, { delims[2] } }
        end
      end,
      delete = function()
        local shared = require('nvim-treesitter-textobjects.shared')
        local outer_textobject = shared.textobject_at_point('@type.outer', 'textobjects', nil, nil,
          { lookahead = false, lookbehind = false })
        if outer_textobject == nil then
          vim.notify('Could not find outer type', vim.log.levels.ERROR)
          return nil
        end
        local inner_textobject = shared.textobject_at_point('@type.inner', 'textobjects', nil, nil,
          { lookahead = false, lookbehind = false })
        if inner_textobject == nil then
          vim.notify('Could not find inner type', vim.log.levels.ERROR)
          return nil
        end
        return {
          left = {
            first_pos = { outer_textobject[1] + 1, outer_textobject[2] + 1 },
            last_pos = { inner_textobject[1] + 1, inner_textobject[2] + 1 },
          },
          right = {
            first_pos = { inner_textobject[4] + 1, inner_textobject[5] },
            last_pos = { outer_textobject[4] + 1, outer_textobject[5] },
          },
        }
      end,
    }
  }
}
