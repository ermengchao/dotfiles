local obj = {}
obj.__index = obj
obj.name = "ToggleAppearance"

obj.hotkeyModifiers = { "ctrl", "cmd" }
obj.hotkeyKey = "t"

function obj:toggleAppearance()
  hs.osascript.applescript([[tell application "System Events" to tell appearance preferences to set dark mode to not dark mode]])
end

function obj:start()
  self:startEventtap()
  return self
end

function obj:stop()
  if self.eventtap then
    self.eventtap:stop()
    self.eventtap = nil
  end

  return self
end

function obj:startEventtap()
  self:stop()

  self.eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    local flags = event:getFlags()
    local key = hs.keycodes.map[event:getKeyCode()]

    if not (flags.fn and flags.ctrl and not flags.cmd and not flags.alt and not flags.shift) then
      return false
    end

    if key ~= self.hotkeyKey then
      return false
    end

    self:toggleAppearance()
    return true
  end)

  self.eventtap:start()

  return self
end

return obj
