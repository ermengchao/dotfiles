local reloadAppearance = hs.loadSpoon("ReloadAppearance")
local switchInputSource = hs.loadSpoon("SwitchInputSource")
local openScreenSaver = hs.loadSpoon("OpenScreenSaver")
local toggleAppearance = hs.loadSpoon("ToggleAppearance")

switchInputSource.displayName = "P2410R"
switchInputSource.vcpValue = "inputSelect"
toggleAppearance.hotkeyModifiers = { "ctrl", "cmd" }
toggleAppearance.hotkeyKey = "t"

reloadAppearance:start()
switchInputSource:start()
openScreenSaver:start()
toggleAppearance:start()
