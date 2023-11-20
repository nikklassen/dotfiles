local cmp = require 'cmp'
local types = require 'cmp.types'
local compare = require 'cmp.config.compare'

local M = {}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local tab_complete = function(fallback)
    if cmp.visible() then
        cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        })
    elseif check_back_space() then
        vim.fn.feedkeys(t('<Tab>'), 'n')
    elseif vim.fn['vsnip#available'](1) == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
    else
        fallback()
    end
end

local s_tab_complete = function()
    if cmp.visible() then
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
        completionItem = e.completion_item,
    })
end

function M.debug_compare(e1, e2)
    print('e1')
    print(dump_entry(e1))
    print('e2')
    print(dump_entry(e2))
end

function M.setup(opts)
    local defaults = {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        experimental = {
            ghost_text = true,
        },
        mapping = {
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),

            ['<CR>'] = cmp.mapping.confirm(),
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
            comparators = {
                compare.offset,
                compare.exact,
                -- compare.scopes,
                compare.score,
                compare.recently_used,
                compare.locality,
                compare.kind,
                -- compare.sort_text,
                compare.length,
                compare.order,
            },
        },
        formatting = {
            format = require 'lspkind'.cmp_format({
                mode = 'symbol',
                maxwidth = 50,
                preset = 'codicons',
                before = function(entry, vim_item)
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
            }),
        },
        sources = {
            { name = 'nvim_lsp' },
        },
        matching = {
            disallow_partial_fuzzy_matching = false,
        },
    }
    cmp.setup(vim.tbl_deep_extend('force', defaults, opts))
    cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
end

return M
