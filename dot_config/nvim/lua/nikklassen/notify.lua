local notify = require('notify')
local nk_utils = require('nikklassen.utils')

local M = {
  ---@type Queue<function>?
  _queue = nil
}

---@generic R
---@class Queue
---@field private _items table<R>
---@field private _waiting function?
local Queue = {}
Queue.__index = Queue

---@generic R
---@return Queue<R>
function Queue.new()
  local q = {
    _items = {},
    _waiting = nil,
  }
  setmetatable(q, Queue)
  return q
end

---@generic R
---@param val R
function Queue:push(val)
  local cb = self._waiting
  if cb then
    self._waiting = nil
    cb(val)
  else
    table.insert(self._items, val)
  end
end

---@generic R
---@return R
function Queue:pop()
  if #self._items > 0 then
    return table.remove(self._items, 1)
  end
  return vim.async.await(function(done)
    self._waiting = done
    return {
      close = function(cb)
        if self._waiting == done then
          self._waiting = nil
        end
        if cb then
          cb()
        end
      end,
    }
  end)
end

local function event_loop()
  while true do
    local event = M._queue:pop()
    nk_utils.notify_on_error(vim.async.run(event)):detach()
    vim.async.sleep(400)
  end
end

local function start_loop()
  M._queue = Queue.new()
  nk_utils.notify_on_error(vim.async.run(event_loop)):detach()
end


M.AsyncNotification = {}
M.AsyncNotification.__index = M.AsyncNotification

function M.AsyncNotification:set_message(message)
  M._queue:push(function()
    self.message = message
    self:_update_notification()
  end)
end

function M.AsyncNotification:_update_notification()
  if self._notification == nil then
    self:_reopen()
  else
    self._notification = notify(self.message, nil, { replace = self._notification })
  end
end

function M.AsyncNotification:_reopen()
  self._notification = notify(self.message, vim.log.levels.INFO, {
    hide_from_history = true,
    on_close = function()
      self._notification = nil
    end,
  })
end

function M.async()
  if M._queue == nil then
    start_loop()
  end
  local n = {}
  setmetatable(n, M.AsyncNotification)
  return n
end

return M
