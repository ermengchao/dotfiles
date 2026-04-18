local obj = {}
obj.__index = obj

obj.name = "OpenScreenSaver"
obj.version = "0.1"
obj.author = "OpenCode"
obj.homepage = "local"
obj.license = "MIT"

local hotkeyModifiers = { "cmd", "alt" }
local hotkeyKey = "q"

function obj:openScreenSaver()
  hs.execute("open -a ScreenSaverEngine", true)
end

function obj:start()
  self:bindHotkeys()
  return self
end

function obj:stop()
  if self.openScreenSaverHotkey then
    self.openScreenSaverHotkey:delete()
    self.openScreenSaverHotkey = nil
  end

  return self
end

function obj:bindHotkeys()
  self:stop()

  self.openScreenSaverHotkey = hs.hotkey.bind(hotkeyModifiers, hotkeyKey, function()
    self:openScreenSaver()
  end)

  return self
end

return obj
