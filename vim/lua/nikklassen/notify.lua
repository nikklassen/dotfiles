local coop = require('coop')
local uv = require("coop.uv")
local MpscQueue = require('coop.mpsc-queue').MpscQueue
local notify = require('notify')

local M = {}

local function event_loop()
  while true do
    local event = M._queue:pop()
    event()
    uv.sleep(200)
  end
end

local function start_loop()
  M._queue = MpscQueue.new()
  coop.spawn(event_loop)
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
