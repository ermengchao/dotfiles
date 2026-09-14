local obj = {}
obj.__index = obj
obj.name = "LockGopassAgeAgent"

local home = os.getenv("HOME")
local log = hs.logger.new(obj.name, "info")

function obj:lock()
  if self.lockTask and self.lockTask:isRunning() then
    log.i("Lock already in progress")
    return false
  end

  self.lockTask = hs.task.new("/usr/bin/env", function(exitCode, stdOut, stdErr)
    self.lockTask = nil

    if exitCode == 0 then
      log.i("Locked gopass age agent")
    else
      log.e(string.format("Failed to lock gopass age agent (exit %d): %s%s", exitCode, stdOut, stdErr))
    end
  end, {
    "XDG_CONFIG_HOME=" .. home .. "/.config",
    "XDG_DATA_HOME=" .. home .. "/.local/share",
    "XDG_RUNTIME_DIR=" .. home .. "/.local/state",
    "XDG_STATE_HOME=" .. home .. "/.local/state",
    "/opt/homebrew/bin/gopass",
    "age",
    "agent",
    "lock",
  })

  if not self.lockTask:start() then
    self.lockTask = nil
    log.e("Failed to start gopass age agent lock task")
    return false
  end

  return true
end

function obj:start()
  if self.watcher then
    self.watcher:stop()
  end

  self.watcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.screensDidLock then
      log.i("macOS screen locked")
      self:lock()
    end
  end)

  self.watcher:start()
  return self
end

function obj:stop()
  if self.watcher then
    self.watcher:stop()
    self.watcher = nil
  end

  return self
end

return obj
