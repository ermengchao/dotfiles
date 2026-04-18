local reloadAppearance = hs.loadSpoon("ReloadAppearance")
local switchInputSource = hs.loadSpoon("SwitchInputSource")
local openScreenSaver = hs.loadSpoon("OpenScreenSaver")

switchInputSource.displayName = "P2410R"
switchInputSource.vcpValue = "inputSelect"

reloadAppearance:start()
switchInputSource:start()
openScreenSaver:start()
