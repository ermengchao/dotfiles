local obj = {}
obj.__index = obj
obj.name = "SwitchInputSource"

obj.displayName = ""
obj.vcpValue = "inputSelect"

local hotkeyModifiers = { "ctrl", "alt" }
local hotkeyDigits = { "1", "2", "3", "4" }

local function sendNotification(message)
  hs.notify.new({
    title = "Hammerspoon",
    informativeText = message,
  }):send()
end

function obj:sendRequest(ddcValue)
  local url = string.format(
    "http://localhost:55777/set?name=%s&vcp=%s&ddc=%s",
    hs.http.encodeForQuery(self.displayName),
    hs.http.encodeForQuery(tostring(self.vcpValue)),
    hs.http.encodeForQuery(tostring(ddcValue))
  )

  local body, statusCode = hs.http.get(url)
  if statusCode ~= 200 then
    sendNotification(string.format("Switch input source failed (%s).", tostring(statusCode)))
    if body and body ~= "" then
      print("SwitchInputSource response:", body)
    end
    return
  end

  sendNotification(string.format("Switch input source request sent (ddc=%s).", tostring(ddcValue)))
end

function obj:start()
  self:bindHotkeys()
  return self
end

function obj:stop()
  if self.switchInputSourceHotkeys then
    for _, hotkey in ipairs(self.switchInputSourceHotkeys) do
      hotkey:delete()
    end
    self.switchInputSourceHotkeys = nil
  end

  return self
end

function obj:bindHotkeys()
  self:stop()

  self.switchInputSourceHotkeys = {}
  for index, digit in ipairs(hotkeyDigits) do
    local ddcValue = 14 + index
    table.insert(self.switchInputSourceHotkeys, hs.hotkey.bind(hotkeyModifiers, digit, function()
      self:sendRequest(ddcValue)
    end))
  end

  return self
end

return obj
