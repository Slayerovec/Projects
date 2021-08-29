ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function GetCar()
    local PlayerPed = GetPlayerPed(-1)
    local PlayerCoords = GetEntityCoords(PlayerPed)
	return GetClosestVehicle(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 3.9, 0, 71)
end

function GetPlate(vehicle)
	return GetVehicleNumberPlateText(vehicle)
end

function VehicleInFront()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
	local rayHandle = StartShapeTestRay(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, result = GetShapeTestResult(rayHandle)
	return result
end

RegisterNetEvent('slay_pdm:platenil')
AddEventHandler('slay_pdm:platenil', function()
	local vehicle = GetCar()
	local plates = GetPlate(vehicle)
	local vehiclass = GetVehicleClass(vehicle)
	local _,n = plates:gsub('%S+',"")
	if n == 1 then
		if vehiclass ~= 13 and vehiclass ~= 14 and vehiclass ~= 15 and vehiclass ~= 16 and vehiclass ~= 17 and vehiclass ~= 18 and vehiclass ~= 19 and vehiclass ~= 21 then
			if IsPedInAnyVehicle(PlayerPedId(), true) == false then
				ESX.TriggerServerCallback('slay_pdm:checkvehicle', function(owned)
					if owned then
						if GetDistanceBetweenCoords(GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle), GetEntityCoords(GetPlayerPed(-1)), true) > GetDistanceBetweenCoords(GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle) * -1, GetEntityCoords(GetPlayerPed(-1)), true) and VehicleInFront() > 0 then
							TriggerServerEvent('slay_pdm:checkgetPlate', plates, vehicle)
						else
							exports["tchaj_notify"]:Notify('error', ('Musíš jít ke kufru!'))
						end
					else
						exports["tchaj_notify"]:Notify('error', ('Nemůžeš krást cizí SPZ!'))
					end
				end, plates)
			else
				exports["tchaj_notify"]:Notify('error', ('Nesmíš sedět v autě!'))
			end
		else
			exports["tchaj_notify"]:Notify('error', ('NONONONONONONONONONO'))
		end
	else
		exports["tchaj_notify"]:Notify('error', ('Na tomto vozidle není SPZ!'))
	end
end)

RegisterNetEvent('slay_pdm:plate')
AddEventHandler('slay_pdm:plate', function(plate, status)
	if status then
		PlayAnim()
		TriggerServerEvent('slay_pdm:getPlate', plate)
		Citizen.Wait(7400)
		TriggerServerEvent("esx_inventoryhud:getPlate")
		exports["tchaj_notify"]:Notify('success', ('Sundal si SPZ %s'):format(plate))
	else
		TriggerServerEvent("esx_inventoryhud:getPlate")
		exports["tchaj_notify"]:Notify('error', ('Tuhle SPZ už máš! %s'):format(plate))
	end 
end)

RegisterNetEvent('slay_pdm:setplate')
AddEventHandler('slay_pdm:setplate', function(plate, status, vehicle)
	if status == 'set' then
		Citizen.Wait(7400)
		SetVehicleNumberPlateText(vehicle, '')
	elseif status == 'reset' then 
		SetVehicleNumberPlateText(vehicle, plate)
	end
end)

RegisterNetEvent('slay_pdm:checkuseplate')
AddEventHandler('slay_pdm:checkuseplate', function(plate)
	local vehicle = GetCar()
	plates = GetPlate(vehicle)
	local _,n = plates:gsub('%S+',"")
	if n == 0 then
		if IsPedInAnyVehicle(PlayerPedId(), true) == false then
			if GetDistanceBetweenCoords(GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle), GetEntityCoords(GetPlayerPed(-1)), true) > GetDistanceBetweenCoords(GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle) * -1, GetEntityCoords(GetPlayerPed(-1)), true) and VehicleInFront() > 0 then
				PlayAnim()
				Citizen.Wait(7400)
				TriggerServerEvent('slay_pdm:useplate', plate, vehicle)
				exports["tchaj_notify"]:Notify('success', ('Nasadil si SPZ %s'):format(plate))
			else
				exports["tchaj_notify"]:Notify('error', ('Musíš jít ke kufru!'))
			end
		else
			exports["tchaj_notify"]:Notify('error', ('Nesmíš sedět v autě!'))
		end
	else
		exports["tchaj_notify"]:Notify('error', ('Nejdřív musíš sundat SPZ!'))
	end
end)