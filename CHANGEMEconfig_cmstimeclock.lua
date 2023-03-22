--[[
    Sonoran Plugins

    Plugin Configuration

    Put all needed configuration in this file.

]]
local config = {
    enabled = true,
    configVersion = "1.0",
    pluginName = "cmstimeclock", -- name your plugin here
    pluginAuthor = "Jordan.2139", -- author

    gracePeriod = 30 -- How long IN SECONDS CAD users have to log back in before clocking out on the CMS (Recommended: 30)
    -- put your configuration options below
}

if config.enabled then
    Config.RegisterPluginConfig(config.pluginName, config)
end