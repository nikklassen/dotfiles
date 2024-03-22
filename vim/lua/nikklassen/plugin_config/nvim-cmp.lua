local cmp = require 'cmp'
local types = require 'cmp.types'
local compare = require 'cmp.config.compare'

local M = {}

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local tab_complete = function(fallback)
  if cmp.visible() then
    cmp.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  elseif vim.snippet.jumpable(1) then
    vim.snippet.jump(1)
  else
    fallback()
  end
end

local s_tab_complete = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif vim.snippet.jumpable(-1) then
    vim.snippet.jump(-1)
  else
    fallback()
  end
end

local function dump_entry(e)
  return vim.inspect({
    id = e.id,
    offset = e:get_offset(),
    sortText = e.completion_item.sortText,
    completionItem = e.completion_item,
  })
end

local function cmpConfirm()
  if not cmp.visible() then
    return false
  end
  local entry = cmp.get_selected_entry()
  if entry == nil then
    return false
  end
  local selected
  if vim.tbl_get(entry, 'completion_item', 'additionalTextEdits') == nil then
    selected = vim.tbl_get(entry, 'completion_item', 'textEdit', 'newText')
  end
  if selected ~= nil then
    local line = vim.fn.getline('.') -- @type string
    if line:sub( -#selected) == selected then
      cmp.close()
      return false
    end
  end
  cmp.confirm()
  return true
end

local function confirm(fallback)
  if not cmpConfirm() then
    fallback()
  end
end


function M.debug_compare(e1, e2)
  print('e1')
  print(dump_entry(e1))
  print('e2')
  print(dump_entry(e2))
end

function M.setup(opts)
  local comparators = vim.tbl_get(opts, 'sorting', 'comparators') or {
    compare.offset,
    compare.exact,
    compare.score,
    compare.recently_used,
    compare.locality,
    compare.kind,
    compare.length,
    compare.order,
  }
  local sources = vim.tbl_get(opts, 'sources') or {
    { name = 'nvim_lsp' },
  }
  if vim.env.NVIM_DISABLE_COPILOT ~= '1' then
    table.insert(sources, 1, { name = 'copilot' })
    table.insert(comparators, 1, require("copilot_cmp.comparators").prioritize)
  end
  local defaults = {
    preselect = cmp.PreselectMode.None,
    experimental = {
      ghost_text = true,
    },
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),

      ['<CR>'] = cmp.mapping(confirm, { 'i', 's' }),
      ['<C-y>'] = cmp.mapping.confirm({
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
      }),

      ['<Tab>'] = cmp.mapping(tab_complete, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(s_tab_complete, { 'i', 's' }),

      ['<C-N>'] = cmp.mapping({
        i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
      }),
      ['<C-p>'] = cmp.mapping({
        i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
      }),

      ['<Down>'] = cmp.mapping({
        i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
      }),
      ['<Up>'] = cmp.mapping({
        i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
      }),
    },
    sorting = {
      priority_weight = 2,
      comparators = comparators,
    },
    formatting = {
      format = require 'lspkind'.cmp_format({
        mode = 'symbol',
        maxwidth = 40,
        preset = 'codicons',
        before = function(entry, vim_item)
          local before = vim.tbl_get(opts, 'formatting', 'cmp_format', 'before')
          if before then
            before(entry, vim_item)
          end

          local ci = entry.completion_item
          if ci.labelDetails then
            vim_item.abbr = string.gsub(vim_item.abbr, '~$', '')
            if ci.labelDetails.detail then
              vim_item.abbr = vim_item.abbr .. ci.labelDetails.detail
            end
            vim_item.menu = ci.labelDetails.description
          end
          return vim_item
        end,
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "󰅩",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          ML = "󱗿",
          TypeParameter = "",
          Copilot = "",
        },
      }),
    },
    sources = sources,
    matching = {
      disallow_partial_fuzzy_matching = false,
    },
  }
  cmp.setup(vim.tbl_deep_extend('force', defaults, opts))
  cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
end

return M

