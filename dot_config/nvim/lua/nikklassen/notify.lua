local async = vim.async
local notify = require('notify')
local nk_utils = require('nikklassen.utils')

local M = {}

local function new_queue()
  local items = {}
  local waiting = nil
  return {
    push = function(self, val)
      if waiting then
        local cb = waiting
        waiting = nil
        cb(val)
      else
        table.insert(items, val)
      end
    end,
    pop = function(self)
      if #items > 0 then
        return table.remove(items, 1)
      end
      return async.await(function(done)
        waiting = done
        return {
          close = function(self, cb)
            if waiting == done then
              waiting = nil
            end
            if cb then
              cb()
            end
          end,
        }
      end)
    end,
  }
end

local function event_loop()
  while true do
    local event = M._queue:pop()
    vim.schedule(nk_utils.wrap_notify_on_error(event))
    async.sleep(400)
  end
end

local function start_loop()
  M._queue = new_queue()
  async.run(nk_utils.wrap_notify_on_error(event_loop))
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
