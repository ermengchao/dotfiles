local obj = {}
obj.__index = obj
obj.name = "WindowNavigation"

obj.hotkeys = {
  left = "h",
  down = "j",
  up = "k",
  right = "l",
}

function obj:focusWindowUp()
  local win = hs.window.frontmostWindow()
  if win then
    win:focusWindowNorth()
  end
end

function obj:focusWindowDown()
  local win = hs.window.frontmostWindow()
  if win then
    win:focusWindowSouth()
  end
end

function obj:focusWindowLeft()
  local win = hs.window.frontmostWindow()
  if win then
    win:focusWindowWest()
  end
end

function obj:focusWindowRight()
  local win = hs.window.frontmostWindow()
  if win then
    win:focusWindowEast()
  end
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

    if key == self.hotkeys.up then
      self:focusWindowUp()
      return true
    end

    if key == self.hotkeys.down then
      self:focusWindowDown()
      return true
    end

    if key == self.hotkeys.left then
      self:focusWindowLeft()
      return true
    end

    if key == self.hotkeys.right then
      self:focusWindowRight()
      return true
    end

    return false
  end)

  self.eventtap:start()

  return self
end

return obj
