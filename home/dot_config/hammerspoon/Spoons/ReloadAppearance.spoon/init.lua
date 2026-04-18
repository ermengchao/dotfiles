local obj = {}
obj.__index = obj

obj.name = "ReloadAppearance"
obj.version = "0.1"
obj.author = "OpenCode"
obj.homepage = "local"
obj.license = "MIT"

local function isDarkMode()
  return hs.host.interfaceStyle() == "Dark"
end

local function sendNotification(message)
  hs.notify.new({
    title = "Hammerspoon",
    informativeText = message,
  }):send()
end

function obj:notifyAppearanceChanged()
  local modeName = isDarkMode() and "Dark" or "Light"
  sendNotification("macOS switched to " .. modeName .. " mode. Reloading appearance settings.")
end

function obj:reloadAppearance()
  local ok, _, _, rc = hs.execute("fish -c reload_appearance", true)
  if not ok or rc ~= 0 then
    sendNotification("Failed to run reload_appearance.")
    return
  end

  self:notifyAppearanceChanged()
end

function obj:start()
  self:reloadAppearance()

  if not self.themeWatcher then
    self.themeWatcher = hs.distributednotifications.new(function()
      self:reloadAppearance()
    end, "AppleInterfaceThemeChangedNotification")
  end

  self.themeWatcher:start()
  return self
end

function obj:stop()
  if self.themeWatcher then
    self.themeWatcher:stop()
  end

  return self
end

return obj
