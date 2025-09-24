local function init_lua_ls(client)
  local path = ''
  if client.workspace_folders ~= nil then
    path = client.workspace_folders[1].name
  end
  if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
    return
  end
  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
    runtime = {
      version = 'LuaJIT'
    },
    -- Make the server aware of Neovim runtime files
    workspace = {
      checkThirdParty = false,
      -- library = vim.list_extend({
      --   vim.env.VIMRUNTIME,
      -- }, vim.api.nvim_get_runtime_file('', true)),
      library = {
        vim.env.VIMRUNTIME,
        vim.fn.stdpath('data') .. '/lazy/TODO',
        vim.fn.stdpath('config') .. '/lua',
        vim.env.PWD,
      },
    },
    completion = {
      callSnippet = 'Replace',
    }
  })
end

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_size = '2',
          indent_style = 'space',
          quote_style = 'single',
        },
      },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
        paramName = 'Literal',
      },
    },
  },
  on_init = init_lua_ls,
})
vim.lsp.enable('lua_ls')
