-----------------------------------
--- Boat Trailer, Made by FAXES ---
-----------------------------------

--- Config ---

attachKey = 51 -- Index number for attach key - http://docs.fivem.net/game-references/controls/
attachKeyName = "~INPUT_CONTEXT~" -- Key name (center column) of above key.
attachCars = {
	[1] = {name ='DINGHY', z = 0.25, y = -1.0},
	[2] = {name = 'DINGHY2', z = 0.25, y = -1.0},
	[3] = {name ='DINGHY3', z = 0.25, y = -1.0},
	[4] = {name = 'DINGHY4', z = 0.25, y = -1.0},
	[5] = {name = 'SEASHARK', z = 0.05, y = -1.0},
	[6] = {name = 'SEASHARK2', z = 0.05, y = 1.0},
	[7] = {name = 'SEASHARK3', z = 0.05, y = -1.0},
	[8] = {name ='CGDINGHY', z = 0.25, y = -1.0},
}

--- Code ---

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1) -- Made the whole thing forgot to add this line lol, maybe thats why it broke #4:32AMLife
        local veh = GetVehiclePedIsIn(ped)
        if veh ~= nil then
        	for i = 1, #attachCars do
	            if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == attachCars[i].name then -- After a few hours here at 4am GetDisplayNameFromVehicleModel() got it working well :P
	                local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 0.0, 0.0, -1.0)
					local boatCoordsInWorldLol = GetEntityCoords(veh)
	                local trailerLoc = GetVehicleInDirection(boatCoordsInWorldLol, belowFaxMachine)
	                
					if GetDisplayNameFromVehicleModel(GetEntityModel(trailerLoc)) == "BOATTRAILER" then -- Is there a trailer????
	                    if IsEntityAttached(veh) then -- Is boat already attached?
	                        if IsControlJustReleased(1, attachKey) then -- detach
								DetachEntity(veh, false, true)
							end
	                        -- Start Prompt
	                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
							Citizen.InvokeNative(0x5F68520888E69014, "Zmackni " .. attachKeyName .. " k uvolneni lodi.") -- AddTextComponentScaleform()
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
	                    else
	                        if IsControlJustReleased(1, attachKey) then -- Attach
								SetVehicleFixed(veh)
								SetVehicleDeformationFixed(veh)
								SetVehicleUndriveable(veh, false)
								SetVehicleEngineHealth(veh, 1000.0)
								SetVehicleBodyHealth(veh, 1000.0)
								SetVehiclePetrolTankHealth(veh, 1000.0)
								AttachEntityToEntity(veh, trailerLoc, 20, 0.0, attachCars[i].y, attachCars[i].z, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
								TaskLeaveVehicle(ped, veh, 64)
	                        end
	                        -- Start Prompt
	                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
							Citizen.InvokeNative(0x5F68520888E69014, "Zmackni " .. attachKeyName .. " k pripevneni lodi.") -- AddTextComponentScaleform()
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
	                        -- Made by Faxes with some help of the bois
						end
	                end
            	end
            end
        end
    end
    -- Just a comment here. Why the fuck not? Its 6 am now
end)
-- All done, only lots of bullshit with code lol. Timestamp, its not 6:15AM. Why we still here? Just to suffer?