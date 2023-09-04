local cmp = require'cmp'
local types = require'cmp.types'
local compare = require'cmp.config.compare'
local utils = require'nikklassen.utils'
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
local lspkind = require'lspkind'

local M = {}

local local_cmp = {}
if utils.isModuleAvailable('local.nvim-cmp') then
    local_cmp = require'local.nvim-cmp'
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space ()
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

function M.response_index(e1, e2)
    local ri1 = e1.completion_item.response_index
    local ri2 = e2.completion_item.response_index
    if ri1 == nil and ri2 == nil then
        return nil
    elseif ri1 == nil then
        return true
    elseif ri2 == nil then
        return false
    else
        return ri1 < ri2
    end
end

function M.configure()
    cmp.setup {
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

            ['<CR>'] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace,
            }),
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
            comparators = vim.list_extend(
                vim.tbl_get(local_cmp, 'setup', 'sorting', 'comparators') or {},
                {
                    -- M.debug_compare,
                    compare.sort_text,
                    -- compare.score,
                    -- compare.order,
                    -- M.response_index,
                    -- compare.offset,
                    -- compare.exact,
                    -- compare.kind,
                    -- compare.length,
                }
            ),
        },

        formatting = {
            format = lspkind.cmp_format({
                mode = 'symbol',
                maxwidth = 50,
                menu = {
                    nvim_lsp = '[LSP]',
                },
            }),
        },

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
        }),
    }
    local cmp_autopairs_on_done = cmp_autopairs.on_confirm_done()
    cmp.event:on('confirm_done', function(evt)
        local status, err = pcall(cmp_autopairs_on_done, evt)
        if not status then
            print(err)
        end
    end)
end

return M
