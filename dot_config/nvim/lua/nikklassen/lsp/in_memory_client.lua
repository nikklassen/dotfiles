---@alias MethodHandler function(params: any)

---@class Client
---@field _dispatchers vim.lsp.rpc.Dispatchers
---@field _capabilities lsp.ClientCapabilities
---@field _methods { [string]: MethodHandler }
---@field _request_id number
---@field _closing boolean
local Client = {}

---@param dispatchers vim.lsp.rpc.Dispatchers
---@param capabilities lsp.ClientCapabilities
---@param methods { [string]: function }
---@return Client
function Client.new(dispatchers, capabilities, methods)
  return setmetatable({
    _dispatchers = dispatchers,
    _request_id = 0,
    _closing = false,
    _capabilities = capabilities,
    _methods = methods,
  }, { __index = Client })
end

function Client:request(method, params, callback)
  local result
  if method == 'initialize' then
    result = self._capabilities
  elseif method == 'shutdown' then
    -- no-op
  elseif self._methods[method] ~= nil then
    result = self._methods[method](params)
  end
  callback(nil, result)
  self._request_id = self._request_id + 1
  return true, self._request_id
end

function Client:notify(method)
  if method == 'exit' then
    self._dispatchers.on_exit(0, 15)
  end
end

function Client:is_closing() return self._closing end

function Client:terminate() self._closing = true end

function Client:cmd()
  return {
    request = function(...) self:request(...) end,
    notify = function(...) self:notify(...) end,
    is_closing = function() self:is_closing() end,
    terminate = function() self:terminate() end,
  }
end

return Client
