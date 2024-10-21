local nio = require("nio")
local notify = require('notify')

local M = {}

M.AsyncNotification = {}
M.AsyncNotification.__index = M.AsyncNotification

function M.AsyncNotification:set_message(message)
  nio.sleep(250)
  self.message = message
  self:_update_notification()
end

function M.AsyncNotification:_update_notification()
  if self._future ~= nil then
    self._future.wait()
  end
  if self._notification == nil then
    self:_reopen()
  else
    self._notification = notify(self.message, nil, { replace = self._notification })
  end
end

function M.AsyncNotification:_reopen()
  self._future = nio.control.future()

  self._notification = notify(self.message, vim.log.levels.INFO, {
    hide_from_history = true,
    on_close = function()
      self._notification = nil
      if not self._future.is_set() then
        self._future.set()
      end
    end,
  })
  vim.defer_fn(function()
    self._future.set()
  end, 100)
end

function M.async()
  local n = {}
  setmetatable(n, M.AsyncNotification)
  return n
end

return M
