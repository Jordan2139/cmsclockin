--[[
    Sonaran CAD Plugins

    Plugin Name: CMS Timeclock
    Creator: Jordan.#2139
    Description: Clock in and out on the Sonoran CMS via SonoranCAD

    Put all server-side logic in this file.
]] local activeUnits = {};
local foundUnit = false;
CreateThread(function()
	Config.LoadPlugin('cmstimeclock', function(pluginConfig)
		if pluginConfig.enabled then
			exports['sonorancad']:registerApiType('GET_ACTIVE_UNITS', 'emergency')

			AddEventHandler('SonoranCAD::pushevents:UnitLogin', function(unit)
				activeUnits[unit.id] = unit
				TriggerEvent('SonoranCMS::pushevents::UnitLogin', unit.accId)
			end)

			AddEventHandler('SonoranCAD::pushevents:UnitLogout', function(id)
				if activeUnits[id] ~= nil then
					Wait(pluginConfig.gracePeriod * 1000)
					exports['sonorancad']:performApiRequest({{['serverId'] = GetConvar('sonoran_serverId', '1')}}, 'GET_ACTIVE_UNITS', function(res)
						if res ~= nil and type(res) == 'table' then
							for i, value in pairs(res) do
								if value.accId == activeUnits[id].accId then
									foundUnit = true
									return
								end
							end
						end
						if not foundUnit then
							TriggerEvent('SonoranCMS::pushevents::UnitLogout', activeUnits[id].accId)
							activeUnits[id] = nil
						end
					end)
				end
			end)
		end
	end)
end)
