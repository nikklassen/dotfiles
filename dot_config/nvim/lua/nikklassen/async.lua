local async = vim.async

local uv = {
  fs_close = async.wrap(2, vim.uv.fs_close),
  fs_fstat = async.wrap(2, vim.uv.fs_fstat),
  fs_lstat = async.wrap(2, vim.uv.fs_lstat),
  fs_open = async.wrap(4, vim.uv.fs_open),
  fs_read = async.wrap(4, vim.uv.fs_read),
  fs_stat = async.wrap(2, vim.uv.fs_stat),
  fs_unlink = async.wrap(2, vim.uv.fs_unlink),
  fs_write = async.wrap(4, vim.uv.fs_write),
}

local function lsp_request(client, method, params, bufnr)
  return async.await(function(done)
    local success, request_id = client:request(method, params, function(...)
      done(...)
    end, bufnr)
    if not success then
      done('Could not send the request for ' .. method .. '.')
      return
    end
    return {
      close = function(self, cb)
        if request_id and client.cancel_request then
          client:cancel_request(request_id)
        end
        if cb then
          cb()
        end
      end,
    }
  end)
end

local function system(cmd, opts)
  return async.await(function(done)
    local obj = vim.system(cmd, opts, vim.schedule_wrap(function(res)
      if res then
        res.result = function()
          return res.code
        end
        res.await = function()
          return res.code
        end
      end
      done(res)
    end))
    return {
      close = function(self, cb)
        obj:kill(15)
        if cb then
          cb()
        end
      end,
    }
  end)
end

local M = {
  uv = uv,
  lsp = {
    request = lsp_request,
  },
  vim = {
    system = system,
  },
}

return M
