local cmp = require'cmp'
local types = require'cmp.types'
local compare = require'cmp.config.compare'
local utils = require'nikklassen.utils'

local M = {}

local local_cmp = {}
if utils.isModuleAvailable('local.nvim-cmp') then
    local_cmp = require'local.nvim-cmp'
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local escape_completion = function()
    if not cmp.visible() or cmp.get_selected_entry() == nil then
        vim.fn.feedkeys(t('<Esc>'), 'n')
    else
        cmp.close()
    end
end

local confirm_completion = function (fallback)
    if not cmp.visible() then
        vim.fn.feedkeys(t('<Plug>delimitMateCR'), '')
    elseif cmp.get_selected_entry() ~= nil then
        cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        })
    else
        cmp.close()
        fallback()
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

local s_tab_complete = function ()
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

        mapping = {
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<Esc>'] = escape_completion,

            ['<CR>'] = confirm_completion,
            ['<C-y>'] = cmp.mapping.confirm('<C-y>'),

            ['<Tab>'] = cmp.mapping(tab_complete, {'i', 's'}),
            ['<S-Tab>'] = cmp.mapping(s_tab_complete, {'i', 's'}),

            ['<Down>'] = cmp.mapping({
                i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
                c = function(fallback)
                    cmp.close()
                    vim.schedule(cmp.suspend())
                    fallback()
                end,
            }),
            ['<Up>'] = cmp.mapping({
                i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
                c = function(fallback)
                    cmp.close()
                    vim.schedule(cmp.suspend())
                    fallback()
                end,
            }),
        },

        sorting = {
            comparators = vim.list_extend(
                vim.tbl_get(local_cmp, 'setup', 'sorting', 'comparators') or {},
                {
                    -- M.debug_compare,
                    compare.score,
                    compare.order,
                    compare.sort_text,
                    M.response_index,
                    -- compare.offset,
                    -- compare.exact,
                    -- compare.kind,
                    -- compare.length,
                }
            ),
        },

        formatting = {
            format = function(entry, vim_item)
                if #vim_item.word > 50 then
                    vim_item.abbr = vim_item.word:sub(0, 50) .. '...'
                end
                vim_item.menu = entry.completion_item.detail
                if entry:get_completion_item().dependency then
                    vim_item.menu = (vim_item.menu or '') .. ' ' .. entry:get_completion_item().dependency
                end
                return vim_item
            end,
        },

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'nvim_lsp_signature_help' },
        }, {
            -- { name = 'vsnip' },
            -- { name = 'omni' },
        }),

        -- completion = {
        --     autocomplete = false,
        -- },
    }

    -- TODO: try using custom autocompletion
    -- vim.api.nvim_create_autocmd(
    --     {"TextChangedI", "TextChangedP"},
    --     {
    --         callback = function()
    --             local line = vim.api.nvim_get_current_line()
    --             local cursor = vim.api.nvim_win_get_cursor(0)[2]

    --             local current = string.sub(line, cursor, cursor + 1)
    --             -- if current == "." or current == "," or current == " " then
    --             if current == "," or current == " " then
    --                 require('cmp').close()
    --             end

    --             local before_line = string.sub(line, 1, cursor + 1)
    --             -- local after_line = string.sub(line, cursor + 1, -1)
    --             if not string.match(before_line, '^%s+$') then
    --                 require('cmp').complete()
    --             end
    --         end,
    --         pattern = "*"
    --     }
    -- )
end

return M
