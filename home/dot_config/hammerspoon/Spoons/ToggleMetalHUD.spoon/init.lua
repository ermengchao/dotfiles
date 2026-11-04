local obj = {}
obj.__index = obj
obj.name = "ToggleMetalHUD"

obj.hotkeyModifiers = { "ctrl", "alt", "shift", "cmd" }
obj.hotkeyKey = "h"

-- Official Metal icon: https://developer.apple.com/assets/elements/icons/metal/metal-256x256_2x.png
local notificationIcon = hs.image.imageFromPath(hs.spoons.resourcePath("metal.png"))

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function notify(message)
  local notification = hs.notify.new({ title = "Metal HUD", informativeText = message })
  if notificationIcon then
    notification:setIdImage(notificationIcon, false)
  end
  notification:send()
end

function obj:runCommand(path, arguments, callback)
  self.task = hs.task.new(path, function(exitCode, stdout, stderr)
    self.task = nil
    callback(exitCode, trim(stdout), trim(stderr))
  end, arguments)

  if not self.task or not self.task:start() then
    self.task = nil
    print("ToggleMetalHUD: could not start " .. path)
    notify("Metal HUD could not be updated.")
  end
end

function obj:toggle()
  if self.task then
    return
  end

  self:runCommand("/bin/launchctl", { "getenv", "MTL_HUD_ENABLED" }, function(exitCode, value, stderr)
    if exitCode ~= 0 then
      print("ToggleMetalHUD: failed to read status: " .. (stderr ~= "" and stderr or "exit code " .. exitCode))
      notify("The current Metal HUD setting could not be read.")
      return
    end

    local arguments
    local message
    if value == "" or value == "0" then
      arguments = { "launchctl", "setenv", "MTL_HUD_ENABLED", "1" }
      message = "Metal HUD is now enabled."
    elseif value == "1" then
      arguments = { "launchctl", "unsetenv", "MTL_HUD_ENABLED" }
      message = "Metal HUD is now disabled."
    else
      print("ToggleMetalHUD: unexpected MTL_HUD_ENABLED value: " .. value)
      notify("Metal HUD was not changed because its current setting is unrecognized.")
      return
    end

    self:runCommand("/usr/bin/env", arguments, function(status, _, errorOutput)
      if status == 0 then
        notify(message)
      else
        print("ToggleMetalHUD: failed to update: " .. (errorOutput ~= "" and errorOutput or "exit code " .. status))
        notify("Metal HUD could not be updated.")
      end
    end)
  end)
end

function obj:start()
  self:stop()
  self.hotkey = hs.hotkey.bind(self.hotkeyModifiers, self.hotkeyKey, function()
    self:toggle()
  end)
  return self
end

function obj:stop()
  if self.hotkey then
    self.hotkey:delete()
    self.hotkey = nil
  end

  if self.task then
    self.task:setCallback(nil)
    self.task:terminate()
    self.task = nil
  end

  return self
end

return obj
