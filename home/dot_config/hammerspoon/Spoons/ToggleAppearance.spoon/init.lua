local obj = {}
obj.__index = obj

obj.name = "ToggleAppearance"
obj.version = "0.1"
obj.author = "OpenCode"
obj.homepage = "local"
obj.license = "MIT"

obj.hotkeyModifiers = { "ctrl", "cmd" }
obj.hotkeyKey = "t"

function obj:toggleAppearance()
  hs.osascript.applescript([[tell application "System Events" to tell appearance preferences to set dark mode to not dark mode]])
end

function obj:start()
  self:bindHotkeys()
  return self
end

function obj:stop()
  if self.toggleAppearanceHotkey then
    self.toggleAppearanceHotkey:delete()
    self.toggleAppearanceHotkey = nil
  end

  return self
end

function obj:bindHotkeys()
  self:stop()

  self.toggleAppearanceHotkey = hs.hotkey.bind(self.hotkeyModifiers, self.hotkeyKey, function()
    self:toggleAppearance()
  end)

  return self
end

return obj
