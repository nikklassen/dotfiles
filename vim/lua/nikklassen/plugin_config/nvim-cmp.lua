local cmp = require'cmp'
local compare = require'cmp.config.compare'

local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local escape_completion = function()
  if vim.fn.pumvisible() == 0 or vim.fn.complete_info()['selected'] == -1 then
    vim.fn.feedkeys(t('<Esc>'), 'n')
  else
    cmp.close()
  end
end

local confirm_completion = function (fallback)
  if vim.fn.pumvisible() == 0 then
    vim.fn.feedkeys(t('<Plug>delimitMateCR'), '')
  elseif vim.fn.complete_info()['selected'] ~= -1 then
    cmp.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  else
    cmp.close()
    fallback()
    -- vim.fn.feedkeys(t('<Plug>delimitMateCR'), '')
  end
end

local function check_back_space ()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local tab_complete = function(fallback)
  if vim.fn.pumvisible() == 1 then
    cmp.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  elseif check_back_space() then
    vim.fn.feedkeys(t('<Tab>'), 'n')
  elseif vim.fn['vsnip#available']() == 1 then
    vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
  else
    fallback()
  end
end

local s_tab_complete = function ()
  if vim.fn.pumvisible() == 1 then
    vim.fn.feedkeys(t('<C-p>'), 'n')
  elseif vim.fn['vsnip#jumpable']() == 1 then
    vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
  else
    vim.fn.feedkeys(t('<S-Tab>'), 'n')
  end
end

local function dump_entry(e)
  return vim.inspect({
    id = e.id,
    offset = e:get_offset(),
    sortText = e.completion_item.sortText,
  })
end

function M.debug_compare(e1, e2)
  print('e1')
  print(dump_entry(e1))
  print('e2')
  print(dump_entry(e2))
end

function M.configure()
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },

    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<Esc>'] = escape_completion,

      ['<CR>'] = confirm_completion,
      ['<C-y>'] =cmp.mapping.confirm("<C-y>"),

      ['<Tab>'] = cmp.mapping(tab_complete, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(s_tab_complete, {'i', 's'}),
    },

    sorting = {
      comparators = {
        compare.order,
        compare.sort_text,
        compare.offset,
        compare.exact,
        compare.score,
        compare.kind,
        compare.length,
      },
    },

    sources = {
      { name = 'nvim_lsp' },
    },
  }
end

return M
