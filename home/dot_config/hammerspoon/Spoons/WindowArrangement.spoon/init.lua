local obj = {}
obj.__index = obj
obj.name = "WindowArrangement"

obj.hotkeys = {
  fullscreen = "f",
  splitLeftRight = "\\",
  splitUpDown = "/",
  topLeft = "q",
  left = "a",
  center = "s",
  restore = "r",
  topRight = "e",
  bottomLeft = "z",
  right = "d",
  up = "w",
  down = "x",
  bottomRight = "c",
}

obj.savedFrames = {}
obj.lastWindow = nil
obj.previousWindow = nil
obj.lastSplit = nil

local function isClose(a, b)
  return math.abs(a - b) < 2
end

function obj:isSameSplitContext(splitType, currentWindow, previousWindow)
  if not self.lastSplit then
    return false
  end

  return self.lastSplit.type == splitType and
      self.lastSplit.currentWindowId == currentWindow:id() and
      self.lastSplit.previousWindowId == previousWindow:id()
end

function obj:saveWindowFrame(win)
  local windowId = win:id()
  if not windowId then
    return
  end

  if self.savedFrames[windowId] then
    return
  end

  local frame = win:frame()
  self.savedFrames[windowId] = {
    x = frame.x,
    y = frame.y,
    w = frame.w,
    h = frame.h,
  }
end

function obj:withFocusedWindow(callback)
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screenFrame = win:screen():frame()
  callback(win, screenFrame)
end

function obj:trackFocusedWindow(window)
  if self.lastWindow and self.lastWindow ~= window then
    self.previousWindow = self.lastWindow
  end

  self.lastWindow = window
end

function obj:moveWindowLeft()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h))
  end)
end

function obj:moveWindowRight()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h))
  end)
end

function obj:moveWindowUp()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h / 2))
  end)
end

function obj:moveWindowDown()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y + screenFrame.h / 2, screenFrame.w, screenFrame.h / 2))
  end)
end

function obj:centerWindow()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    local frame = win:frame()
    frame.x = screenFrame.x + (screenFrame.w - frame.w) / 2
    frame.y = screenFrame.y + (screenFrame.h - frame.h) / 2
    win:setFrame(frame)
  end)
end

function obj:restoreWindow()
  self:withFocusedWindow(function(win)
    local windowId = win:id()
    local savedFrame = windowId and self.savedFrames[windowId]
    if not savedFrame then
      return
    end

    win:setFrame(hs.geometry.rect(savedFrame.x, savedFrame.y, savedFrame.w, savedFrame.h))
    self.savedFrames[windowId] = nil
  end)
end

function obj:moveWindowTopLeft()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h / 2))
  end)
end

function obj:moveWindowTopRight()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h / 2))
  end)
end

function obj:moveWindowBottomLeft()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y + screenFrame.h / 2, screenFrame.w / 2, screenFrame.h / 2))
  end)
end

function obj:moveWindowBottomRight()
  self:withFocusedWindow(function(win, screenFrame)
    self:saveWindowFrame(win)
    win:setFrame(hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y + screenFrame.h / 2, screenFrame.w / 2, screenFrame.h / 2))
  end)
end

function obj:toggleFullscreen()
  self:withFocusedWindow(function(win)
    win:toggleFullScreen()
  end)
end

function obj:splitWindowsLeftRight()
  local currentWindow = hs.window.focusedWindow()
  local previousWindow = self.previousWindow
  if not currentWindow or not previousWindow or currentWindow == previousWindow then
    return
  end

  local screenFrame = currentWindow:screen():frame()
  local currentFrame = currentWindow:frame()
  local previousFrame = previousWindow:frame()
  local shouldSwap = self:isSameSplitContext("left_right", currentWindow, previousWindow) and not self.lastSplit.swapped

  self:saveWindowFrame(currentWindow)
  self:saveWindowFrame(previousWindow)

  if shouldSwap or isClose(currentFrame.x, screenFrame.x) and isClose(currentFrame.w, screenFrame.w / 2) and
      isClose(previousFrame.x, screenFrame.x + screenFrame.w / 2) and isClose(previousFrame.w, screenFrame.w / 2) then
    currentWindow:setFrame(hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h))
    previousWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h))
    self.lastSplit = {
      type = "left_right",
      currentWindowId = currentWindow:id(),
      previousWindowId = previousWindow:id(),
      swapped = true,
    }
    return
  end

  currentWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h))
  previousWindow:setFrame(hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h))
  self.lastSplit = {
    type = "left_right",
    currentWindowId = currentWindow:id(),
    previousWindowId = previousWindow:id(),
    swapped = false,
  }
end

function obj:splitWindowsUpDown()
  local currentWindow = hs.window.focusedWindow()
  local previousWindow = self.previousWindow
  if not currentWindow or not previousWindow or currentWindow == previousWindow then
    return
  end

  local screenFrame = currentWindow:screen():frame()
  local currentFrame = currentWindow:frame()
  local previousFrame = previousWindow:frame()
  local shouldSwap = self:isSameSplitContext("up_down", currentWindow, previousWindow) and not self.lastSplit.swapped

  self:saveWindowFrame(currentWindow)
  self:saveWindowFrame(previousWindow)

  if shouldSwap or isClose(currentFrame.y, screenFrame.y) and isClose(currentFrame.h, screenFrame.h / 2) and
      isClose(previousFrame.y, screenFrame.y + screenFrame.h / 2) and isClose(previousFrame.h, screenFrame.h / 2) then
    currentWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y + screenFrame.h / 2, screenFrame.w, screenFrame.h / 2))
    previousWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h / 2))
    self.lastSplit = {
      type = "up_down",
      currentWindowId = currentWindow:id(),
      previousWindowId = previousWindow:id(),
      swapped = true,
    }
    return
  end

  currentWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h / 2))
  previousWindow:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y + screenFrame.h / 2, screenFrame.w, screenFrame.h / 2))
  self.lastSplit = {
    type = "up_down",
    currentWindowId = currentWindow:id(),
    previousWindowId = previousWindow:id(),
    swapped = false,
  }
end

function obj:start()
  if not self.windowFilterSubscription then
    self.windowFilterSubscription = hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window)
      self:trackFocusedWindow(window)
    end)
  end

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

    if key == self.hotkeys.left then
      self:moveWindowLeft()
      return true
    end

    if key == self.hotkeys.topLeft then
      self:moveWindowTopLeft()
      return true
    end

    if key == self.hotkeys.right then
      self:moveWindowRight()
      return true
    end

    if key == self.hotkeys.topRight then
      self:moveWindowTopRight()
      return true
    end

    if key == self.hotkeys.up then
      self:moveWindowUp()
      return true
    end

    if key == self.hotkeys.down then
      self:moveWindowDown()
      return true
    end

    if key == self.hotkeys.bottomLeft then
      self:moveWindowBottomLeft()
      return true
    end

    if key == self.hotkeys.bottomRight then
      self:moveWindowBottomRight()
      return true
    end

    if key == self.hotkeys.restore then
      self:restoreWindow()
      return true
    end

    if key == self.hotkeys.center then
      self:centerWindow()
      return true
    end

    if key == self.hotkeys.fullscreen then
      self:toggleFullscreen()
      return true
    end

    if key == self.hotkeys.splitLeftRight then
      self:splitWindowsLeftRight()
      return true
    end

    if key == self.hotkeys.splitUpDown then
      self:splitWindowsUpDown()
      return true
    end

    return false
  end)

  self.eventtap:start()

  return self
end

return obj
