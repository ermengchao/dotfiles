local reloadAppearance = hs.loadSpoon("ReloadAppearance")
local switchInputSource = hs.loadSpoon("SwitchInputSource")
local openScreenSaver = hs.loadSpoon("OpenScreenSaver")
local toggleAppearance = hs.loadSpoon("ToggleAppearance")
local windowArrangement = hs.loadSpoon("WindowArrangement")
local windowNavigation = hs.loadSpoon("WindowNavigation")

switchInputSource.displayName = "P2410R"
toggleAppearance.hotkeyModifiers = { "fn", "ctrl" }
toggleAppearance.hotkeyKey = "t"

reloadAppearance:start()
switchInputSource:start()
openScreenSaver:start()
toggleAppearance:start()
windowArrangement:start()
windowNavigation:start()
