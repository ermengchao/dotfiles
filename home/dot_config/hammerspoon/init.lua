require("hs.ipc")

local reloadAppearance = hs.loadSpoon("ReloadAppearance")
local switchInputSource = hs.loadSpoon("SwitchInputSource")
local openScreenSaver = hs.loadSpoon("OpenScreenSaver")
local toggleAppearance = hs.loadSpoon("ToggleAppearance")
local toggleMetalHUD = hs.loadSpoon("ToggleMetalHUD")
local windowArrangement = hs.loadSpoon("WindowArrangement")
local windowNavigation = hs.loadSpoon("WindowNavigation")

switchInputSource.displayName = "H25T7"
switchInputSource.baseDdcValue = 15
toggleAppearance.hotkeyModifiers = { "fn", "ctrl" }
toggleAppearance.hotkeyKey = "t"

reloadAppearance:start()
switchInputSource:start()
openScreenSaver:start()
toggleAppearance:start()
toggleMetalHUD:start()
windowArrangement:start()
windowNavigation:start()

-- Caps Lock is mapped to fn+control by Karabiner.
local keyboardInputSources = {
  ["1"] = "com.apple.keylayout.ABC",
  ["2"] = "com.apple.inputmethod.SCIM.ITABC",
  ["3"] = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
}

-- Retain the event tap so it stays active until the configuration is reloaded.
keyboardInputSourceEventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local flags = event:getFlags()
  if not (flags.fn and flags.ctrl and not flags.cmd and not flags.alt and not flags.shift) then
    return false
  end

  local sourceID = keyboardInputSources[hs.keycodes.map[event:getKeyCode()]]
  if not sourceID then
    return false
  end

  if hs.keycodes.currentSourceID() ~= sourceID and not hs.keycodes.currentSourceID(sourceID) then
    hs.alert.show("Could not select keyboard input source: " .. sourceID)
  end
  return true
end):start()

-- Karabiner invokes this after Caps Lock is held alone for 500 ms.
hs.urlevent.bind("caps-lock-toggle", function()
  -- Read the lock flag from the current keyboard session.
  local capsLockOn = hs.eventtap.checkKeyboardModifiers().capslock
  hs.hid.capslock.set(not capsLockOn)
end)
