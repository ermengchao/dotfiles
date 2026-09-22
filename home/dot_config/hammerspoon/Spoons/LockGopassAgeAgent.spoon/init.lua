local obj = {}
obj.__index = obj
obj.name = "LockGopassAgeAgent"

local home = os.getenv("HOME")
local log = hs.logger.new(obj.name, "info")

function obj:lock()
  local gopassStarted = false
  local sshStarted = false

  if self.gopassLockTask and self.gopassLockTask:isRunning() then
    log.i("Gopass age agent lock already in progress")
    gopassStarted = true
  else
    self.gopassLockTask = hs.task.new("/usr/bin/env", function(exitCode, stdOut, stdErr)
      self.gopassLockTask = nil

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

    if self.gopassLockTask:start() then
      gopassStarted = true
    else
      self.gopassLockTask = nil
      log.e("Failed to start gopass age agent lock task")
    end
  end

  if self.sshClearTask and self.sshClearTask:isRunning() then
    log.i("SSH agent clear already in progress")
    sshStarted = true
  else
    self.sshClearTask = hs.task.new("/usr/bin/ssh-add", function(exitCode, stdOut, stdErr)
      self.sshClearTask = nil

      if exitCode == 0 then
        log.i("Removed all identities from SSH agent")
      else
        log.e(string.format("Failed to clear SSH agent (exit %d): %s%s", exitCode, stdOut, stdErr))
      end
    end, { "-D" })

    if self.sshClearTask:start() then
      sshStarted = true
    else
      self.sshClearTask = nil
      log.e("Failed to start SSH agent clear task")
    end
  end

  return gopassStarted and sshStarted
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
