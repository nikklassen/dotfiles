local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.escape_completion()
  if vim.fn.pumvisible() == 0 or vim.fn.complete_info()['selected'] == -1 then
    return t '<Esc>'
  end
  return t '<C-e>'
end

function _G.confirm_completion()
  if vim.fn.pumvisible() == 0 then
    return t '<Plug>delimitMateCR'
  elseif vim.fn.complete_info()['selected'] ~= -1 then
    return vim.fn['compe#confirm']({ keys = t '<Plug>delimitMateCR', mode = '' })
  else
    return t '<C-e><Plug>delimitMateCR'
  end
end

local function check_back_space ()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
function _G.tab_complete()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', {1}) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

function _G.s_tab_complete()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end

function M.set_keymap(bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = {
    silent = true,
    expr = true,
  }
  buf_set_keymap('i', '<C-Space>', 'compe#complete()', opts)
  buf_set_keymap('i', '<C-e>', 'compe#close("<C-e>")', opts)
  buf_set_keymap('i', '<Esc>', 'v:lua.escape_completion()', opts)

  buf_set_keymap('i', '<CR>', 'v:lua.confirm_completion()', opts)
  buf_set_keymap('i', '<C-y>', 'compe#confirm("<C-y>")', opts)

  buf_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
  buf_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
  buf_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
  buf_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
end

function M.configure()
  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'always';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = false;
      buffer = false;
      calc = false;
      vsnip = true;
      nvim_lsp = true;
      nvim_lua = false;
      spell = false;
      tags = false;
      snippets_nvim = false;
      treesitter = false;
    };
  }
end

return M
