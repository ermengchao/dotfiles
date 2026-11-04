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
