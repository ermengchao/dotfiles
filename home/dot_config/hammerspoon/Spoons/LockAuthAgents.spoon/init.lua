local obj = {}
obj.__index = obj
obj.name = "LockAuthAgents"
obj.version = "1.0.3"
obj.author = "ermengchao"
obj.description = "Lock gopass age agent and reset Secretive authentication on screen lock."

local home = os.getenv("HOME")
local log = hs.logger.new(obj.name, "info")
local secretiveAgentPath = "/Applications/Secretive.app/Contents/Library/LoginItems/SecretAgent.app"
local secretiveAgentBundleID = "com.maxgoedjen.Secretive.SecretAgent"
local stopSecretiveCommand = [[
# PIDs come from Hammerspoon's bundle-ID lookup, not process-name matching.
for pid in "$@"; do
  /bin/kill -TERM "$pid" 2>/dev/null || true
done
for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
  running=0
  for pid in "$@"; do
    if /bin/kill -0 "$pid" 2>/dev/null; then running=1; fi
  done
  if [ "$running" -eq 0 ]; then exit 0; fi
  /bin/sleep 0.1
done
printf '%s\n' 'SecretAgent did not exit within two seconds' >&2
exit 2
]]

function obj:lock()
  local runtimeDir = os.getenv("XDG_RUNTIME_DIR")
  if not runtimeDir or runtimeDir == "" then
    -- GUI apps do not inherit fish settings; macOS supplies the same directory as TMPDIR.
    runtimeDir = os.getenv("TMPDIR")
  end
  local gopassStarted = false
  if self.gopassLockTask and self.gopassLockTask:isRunning() then
    log.i("Gopass age agent lock already in progress")
    gopassStarted = true
  elseif not runtimeDir or runtimeDir == "" then
    log.e("Cannot lock gopass age agent: XDG_RUNTIME_DIR and TMPDIR are unset")
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
      "XDG_RUNTIME_DIR=" .. runtimeDir,
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

  local secretiveStarted = self:stopSecretive()
  return gopassStarted and secretiveStarted
end

function obj:stopSecretive()
  if self.secretiveStopTask and self.secretiveStopTask:isRunning() then
    return true
  end

  local arguments = { "-c", stopSecretiveCommand, "LockAuthAgents" }
  self.lastSecretiveStopPIDs = {}
  for _, app in ipairs(hs.application.applicationsForBundleID(secretiveAgentBundleID)) do
    local pid = app:pid()
    if pid then
      arguments[#arguments + 1] = tostring(pid)
      self.lastSecretiveStopPIDs[#self.lastSecretiveStopPIDs + 1] = pid
    end
  end
  if #self.lastSecretiveStopPIDs == 0 then
    self.lastSecretiveStopExitCode = 1
    log.i("SecretAgent was not running")
    return true
  end

  self.secretiveStopTask = hs.task.new("/bin/sh", function(exitCode, stdOut, stdErr)
    self.secretiveStopTask = nil
    self.lastSecretiveStopExitCode = exitCode
    self.lastSecretiveStopError = stdErr
    if exitCode == 0 then
      self.secretiveNeedsRestart = true
      log.i("Stopped SecretAgent to clear temporary authentication")
      if not self.screenLocked then
        self:startSecretive()
      end
    elseif exitCode == 1 then
      log.i("SecretAgent was not running")
    else
      log.e(string.format("Failed to stop SecretAgent (exit %d): %s%s", exitCode, stdOut, stdErr))
    end
  end, arguments)

  if self.secretiveStopTask:start() then
    return true
  end
  self.secretiveStopTask = nil
  log.e("Failed to start SecretAgent stop task")
  return false
end

function obj:startSecretive()
  if self.screenLocked or not self.secretiveNeedsRestart then
    return false
  end
  if self.secretiveStopTask and self.secretiveStopTask:isRunning() then
    return true
  end
  if self.secretiveStartTask and self.secretiveStartTask:isRunning() then
    return true
  end

  self.secretiveStartTask = hs.task.new("/usr/bin/open", function(exitCode, stdOut, stdErr)
    self.secretiveStartTask = nil
    self.lastSecretiveStartExitCode = exitCode
    self.lastSecretiveStartError = stdErr
    if exitCode == 0 then
      if self.screenLocked then
        -- A new lock can arrive while open is launching the agent.
        self:stopSecretive()
      else
        self.secretiveNeedsRestart = false
        log.i("Requested SecretAgent startup")
      end
    else
      log.e(string.format("Failed to start SecretAgent (exit %d): %s%s", exitCode, stdOut, stdErr))
    end
  end, { "-g", secretiveAgentPath })

  if self.secretiveStartTask:start() then
    return true
  end
  self.secretiveStartTask = nil
  log.e("Failed to start SecretAgent startup task")
  return false
end

function obj:start()
  if self.watcher then
    self.watcher:stop()
  end

  self.watcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.screensDidLock then
      self.screenLocked = true
      self.lastScreenEvent = "locked"
      self.lastScreenEventTime = os.time()
      log.i("macOS screen locked")
      self:lock()
    elseif event == hs.caffeinate.watcher.screensDidUnlock then
      self.screenLocked = false
      self.lastScreenEvent = "unlocked"
      self.lastScreenEventTime = os.time()
      log.i("macOS screen unlocked")
      self:startSecretive()
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
