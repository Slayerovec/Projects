local props = {}

function RefreshPed(spawn, PDM, Seller)
	ESX.TriggerServerCallback("slay_pdm:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
			if PDM == nil or Seller == nil then
				for k,v in pairs(Config.Zones) do
					for i = 1, #Config.Zones[k].Seller do
						local Spawn = Config.Zones[k].Seller[i]
						model({ GetHashKey(Spawn.hash) })
						local pedId = CreatePed(5, Spawn.hash, Spawn.Coords.x, Spawn.Coords.y, Spawn.Coords.z - 0.985, Spawn.Coords.h, true)

						SetPedCombatAttributes(pedId, 46, true)
						SetPedFleeAttributes(pedId, 0, 0)
						SetBlockingOfNonTemporaryEvents(pedId, true)

						SetEntityAsMissionEntity(pedId, true, true)
						SetEntityInvincible(pedId, true)

						FreezeEntityPosition(pedId, true)
					end
				end
			else
				local Spawn = Config.Zones[PDM].Seller[Seller]
				model({ GetHashKey(Spawn.hash) })
				local pedId = CreatePed(5, Spawn.hash, Spawn.Coords.x, Spawn.Coords.y, Spawn.Coords.z - 0.985, Spawn.Coords.h, true)

				SetPedCombatAttributes(pedId, 46, true)
				SetPedFleeAttributes(pedId, 0, 0)
				SetBlockingOfNonTemporaryEvents(pedId, true)

				SetEntityAsMissionEntity(pedId, true, true)
				SetEntityInvincible(pedId, true)

				FreezeEntityPosition(pedId, true)
			end
		end
	end)
end

function SpawnPoint(pobocka)
	local spawnPoints 			 	= pobocka.SpawnPoints
	local found, foundSpawnPoint 	= false, nil
	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint 	= true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		return false
	end
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, '_FUEL_LEVEL', GetVehicleFuelLevel(vehicle))
	end
end

function splitter (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function StartAnim(pobocka, PDM, seller)
	local Spawn 								= pobocka.Seller[seller]
	local Location 								= pobocka.Enter[seller] 
	local PedLocation							= pobocka.Seller[seller].Coords
	local closestPed, closestPedDst 			= ESX.Game.GetClosestPed(PedLocation)

	if not NetworkHasControlOfEntity(closestPed) then
		NetworkRequestControlOfEntity(closestPed)
	end

	if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
		RefreshPed(true, PDM, seller)
	end

	SetEntityCoords(closestPed, PedLocation.x, PedLocation.y, PedLocation.z - 0.985)
	SetEntityHeading(closestPed, PedLocation.h)
	SetEntityCoords(PlayerPedId(), Location.Coord.x, Location.Coord.y, Location.Coord.z - 0.985)
	SetEntityHeading(PlayerPedId(), Location.Heading)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('weapon_unarmed'), true)

	local animLib = 'mp_common'

	model({ animLib })

	if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
		PlayAnimationWithKey(closestPed)
		DestroyAllProps(true)
		ClearPedSecondaryTask(GetPlayerPed(-1))
		ClearPedSecondaryTask(closestPed)
	end
	UnloadModels()
end

PlayAnimationWithKey = function(closstPed)
	local prop = nil
	local prop2 = nil
	local prop3 = nil
	local prop4 = nil
    local propName = 'bkr_prop_money_wrapped_01'
	local propName2 = 'p_car_keys_01'
	local anim = 'givetake1_a'
	local anim2 = 'givetake1_b'
	local playerPed = GetPlayerPed(-1)
    local closestPed = closstPed
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
	local x2,y2,z2 = table.unpack(GetEntityCoords(closestPed))
    prop = CreateObject(GetHashKey(propName), x, y, z , true, true, true)
	prop2 = CreateObject(GetHashKey(propName), x2, y2, z2 , true, true, true)
	prop3 = CreateObject(GetHashKey(propName2), x, y, z , true, true, true)
	prop4 = CreateObject(GetHashKey(propName2), x2, y2, z2 , true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 64017)
	local bone2Index = GetPedBoneIndex(closestPed, 64017)

    RequestAnimDict("mp_common")

    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, "mp_common", anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
	TaskPlayAnim(closestPed, "mp_common", anim2, 8.0, -8, -1, 49, 0, 0, 0, 0)
	AttachEntityToEntity(prop, playerPed, boneIndex, 0, 0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(1200)
	DeleteObject(prop)
	AttachEntityToEntity(prop2, closestPed, bone2Index, 0, 0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(1200)
	DeleteObject(prop2)
	Citizen.Wait(1200)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	ClearPedSecondaryTask(closestPed)
	Citizen.Wait(1200)
	TaskPlayAnim(closestPed, "mp_common", anim2, 8.0, -8, -1, 49, 0, 0, 0, 0)
	TaskPlayAnim(playerPed, "mp_common", anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
	AttachEntityToEntity(prop4, closestPed, bone2Index, 0, 0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(1200)
	DeleteObject(prop4)
	AttachEntityToEntity(prop3, playerPed, boneIndex, 0, 0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(1200)
	DeleteObject(prop3)
	FreezeEntityPosition(PlayerPedId(), false)
	table.insert(props, prop)
end

function DestroyAllProps()
	Citizen.Wait(1000)
	for i = 1, #props do
		DeleteObject(props[i])
	end
end

function PlayAnim()
	ESX.Streaming.RequestAnimDict('amb@prop_human_parking_meter@female@idle_a', function()
		TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@female@idle_a', 'idle_c_female', 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
		Citizen.CreateThread(function()
			Citizen.Wait(7500)
			ClearPedTasks(PlayerPedId())
		end)
	end)
	--local animLib = 'rcmfanatic3'
	-- model({ animLib })
	-- NetworkRequestControlOfNetworkId(PedToNet(PlayerPedId()))
	-- TaskPlayAnim(PlayerPedId(), animLib, 'kneel_idle_a', 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
	-- Citizen.Wait(10000)
	-- ClearPedTasks(PlayerPedId())
	-- return true
end

local CachedModels = {}

function model(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

function UnloadModels()
	for modelIndex  = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end

		table.remove(CachedModels, modelIndex)
	end
end
-------------------------------------------------- Stats ----------------------------------------------------------------

function Stats(status, vehicle)
	if Config.Stats then
		jedem = status
		while jedem do
			Citizen.Wait(10)
			veh = GetVehiclePedIsIn(PlayerPedId(), false)
			name = GetDisplayNameFromVehicleModel(GetEntityModel(veh, false))
			if name ~= 'CARNOTFOUND' or veh ~= 0 then
				maxspeed = round(GetVehicleEstimatedMaxSpeed(veh) * 2.23693629,1)
				acceleration = round(GetVehicleAcceleration(veh),1)
				breaking = round(GetVehicleMaxBraking(veh), 1)
				gears = GetVehicleHighGear(veh)
				capacity = GetVehicleMaxNumberOfPassengers(veh) + 1
				doors = GetNumberOfVehicleDoors(veh)
				modVanityPlate = GetNumVehicleMods(veh, 26)
				modRoof = GetNumVehicleMods(veh, 10)
				modFrontBumper = GetNumVehicleMods(veh, 1)
				modRearBumper = GetNumVehicleMods(veh, 2)
				modSideSkirt = GetNumVehicleMods(veh, 3)
				modExhaust = GetNumVehicleMods(veh, 4)
				modHood = GetNumVehicleMods(veh, 7)
				modSpoilers = GetNumVehicleMods(veh, 0)
				modDashboard = GetNumVehicleMods(veh, 29)
				modTrimA = GetNumVehicleMods(veh, 27)
				modFender = GetNumVehicleMods(veh, 8)
				modRightFender = GetNumVehicleMods(veh, 9)
				liverycount = GetVehicleLiveryCount(veh)


				for id=0, 14 do
					if IsVehicleExtraTurnedOn(veh, id) then
						extrascount = id
					end
				end

				if extrascount > 0 then
					extras = '<good>Má Extras</good>'
				else
					extras = '<low> Nemá Extras</low>'
				end

				if liverycount > 0 then
					livery = '<good>Má Liverky</good>'
				else
					livery = '<low> Nemá Liverky</low>'
				end

				if modVanityPlate == 0 then
					modVanityPlate = '<low>0</low>'
				end

				if modRoof == 0 then
					modRoof = '<low>0</low>'
				end
				if modFrontBumper == 0 then
					modFrontBumper = '<low>0</low>'
				end

				if modRearBumper == 0 then
					modRearBumper = '<low>0</low>'
				end

				if modSideSkirt == 0 then
					modSideSkirt = '<low>0</low>'
				end

				if modExhaust == 0 then
					modExhaust = '<low>0</low>'
				end

				if modHood == 0 then
					modHood = '<low>0</low>'
				end
				if modSpoilers == 0 then
					modSpoilers = '<low>0</low>'
				end

				if modDashboard == 0 then
					modDashboard = '<low>0</low>'
				end

				if modFender == 0 then
					modFender = '<low>0</low>'
				end

				if modRightFender == 0 then
					modRightFender = '<low>0</low>'
				end

				if modTrimA == 0 then
					modTrimA = '<low>0</low>'
				end

				SendNUIMessage({
					data = veh,
					name = vehicle,			
					mxspeed = maxspeed,
					acceleration = acceleration,
					breaking = breaking,
					gear = gears,
					capacity = capacity,
					doors = doors,
					extra = extras,
					--livery = livery,
					modVanityPlate = modVanityPlate,
					modRoof = modRoof,
					modFrontBumper = modFrontBumper,
					modRearBumper = modRearBumper,
					modSideSkirt = modSideSkirt,
					modExhaust = modExhaust,
					modHood = modHood,
					modSpoilers = modSpoilers,
					modTrimA = modTrimA,
					modDashboard = modDashboard,
					modFender = modFender,
					modRightFender = modRightFender,
				})
				jedem = false
			else

				SendNUIMessage({
					data = nil,
					name = car,			
					mxspeed = 'Error',
					acceleration = 'Error',
					breaking = 'Error',
					gear = 'Error',
					capacity = 'Error',
					doors = 'Error',
					extra = 'Error',
					--livery = 'Error',
					modVanityPlate = 'Error',
					modRoof = 'Error',
					modFrontBumper = 'Error',
					modRearBumper = 'Error',
					modSideSkirt = 'Error',
					modExhaust = 'Error',
					modHood = 'Error',
					modSpoilers = 'Error',
					modTrimA = 'Error',
					modDashboard = 'Error',
					modFender = 'Error',
					modRightFender = 'Error',
				})
				jedem = false
			end
		end
	end
end

function round(num, numDecimalPlaces)
  local mult = 100^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-------------------------------------------------- SHOWROOM ----------------------------------------------------------------
function ShowRoom(Vehicles)
 	for k,v in pairs(Config.Zones) do
 		picovinametlochapes 								= Config.Zones[k].Category
 		room 				 								= Config.Zones[k].ShowRoom

	 	if room.Active == true then
		 	local showroomcars								= Vehicles
		 	local cars 										= {}
		 	rom 				 							= Config.Zones[k].ShowRoom
		 	pdmka = k

			for key,data in pairs(showroomcars) do
				if data.public ~= true then
		  			for i = 1, #picovinametlochapes, 1 do
		  				if data.category == picovinametlochapes[i] then
		  					jeje = data.category
							table.insert(cars, data)
						end
					end
				end
			end

			local spawnPoints = Config.Zones[k].ShowRoom
			local foundSpawn, SpawnPoint = false, nil
			ESX.TriggerServerCallback('slay_pdm:showroom', function(car)
			color 	= math.random(1, 160)
			repeat
				for i=1, #spawnPoints, 1 do
				if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
						foundSpawn, SpawnPoint 							= true, spawnPoints[i]
						break
					else
						foundSpawn, SpawnPoint 							= false, nil
					end
				end
				
				if foundSpawn then
					ESX.Game.SpawnLocalVehicle(car[1].model, SpawnPoint.coords, SpawnPoint.heading, function(vehicle)
					 	local newPlate     			= 'ShowRoom'
					 	local vehicleProps 			= ESX.Game.GetVehicleProperties(vehicle)
					 	ESX.Game.SetVehicleProperties(vehicle, {color1 = color, color2 = color, pearlescentColor = color, dirtLevel = 0.0})
					 	vehicleProps.plate 			= newPlate
					 	SetVehicleNumberPlateText(vehicle, newPlate)
					 	for i=0,7 do SetVehicleDoorCanBreak(vehicle, i, false) ;SetVehicleDoorOpen(vehicle, i, false, false) end
					 	SetVehicleOnGroundProperly(vehicle)
					 	FreezeEntityPosition(vehicle, true)
					 	SetModelAsNoLongerNeeded(vehicle)
					 	SetEntityInvincible(vehicle, true)
	 					SetVehicleDoorsLocked(vehicle, 2)
	 					SetVehicleUndriveable(vehicle, true)
					end)
				else
					success = true
				end
				Citizen.Wait(500)
				until success
			end, cars, pdmka)
		end
 	end 
end

function ShowRoomSpawnPoint(pdmka)
	local zones = Config.Zones
	room = Config.Zones[pdmka].ShowRoom
	local spawnPoints = room.SpawnPoints
	local found, foundSpawnPoint = false, nil
	if room.Active == true then
		for i=1, #spawnPoints, 1 do
			if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
				found, foundSpawnPoint 							= true, spawnPoints[i]
				break
			end
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		return false
	end
end

---------------------------------------------------- SPZ --------------------------------------------------------------------
local NumberCharset 										= {}
local Charset 												= {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak 			 = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())

			generatedPlate 	 = string.upper(GetRandomNumber(2) .. '' .. GetRandomLetter(3) .. '' .. GetRandomNumber(3))


		ESX.TriggerServerCallback('slay_pdm:checkspz', function (spz)
			if not spz then
				doBreak 	 = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback			= 'waiting'

	ESX.TriggerServerCallback('slay_pdm:checkspz', function(spz)
		callback 		    = spz
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end


---------------------------------------------------- VIN --------------------------------------------------------------------
RegisterNetEvent('slay_pdm:showvin')
AddEventHandler('slay_pdm:showvin', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local vehicle = GetCar()
	local plate = GetPlate(vehicle)
	local vehFront = VehicleInFront()

	closestVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 4.0, 0, 71)
	if IsEntityAVehicle(vehicle) and DoesEntityExist(vehicle) then

		if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(playerPed), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(playerPed), true) and VehicleInFront() > 0 then
			exports.tchaj_notify:Notify('error', 'Jdi ke kapotě!')
		else
			--SetVehicleDoorOpen(vehFront, 4, false, false)
			ESX.TriggerServerCallback('slay_pdm:vin', function (vin)
				--Citizen.Wait(3000)
				TriggerEvent("chatMessage", "[VIN]", {255, 255, 0}, ('%s'):format(vin))
				exports.tchaj_notify:Notify('success', ('VIN: %s'):format(vin))
				--SetVehicleDoorShut(vehFront, 4, false)
			end, DecorGetInt(vehicle, 'Vehicle_UUID'))
		end
	end
end)

RegisterNetEvent('slay_pdm:flip')
AddEventHandler('slay_pdm:flip', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local vehicle = GetCar()
	if IsEntityAVehicle(vehicle) and DoesEntityExist(vehicle) then
		SetVehicleOnGroundProperly(vehicle)
		exports.tchaj_notify:Notify('succes', 'Obratil si auto!')
	end
end)



local VINNumberCharset = {}
local VINCharset = {}
for i = 48,  57 do table.insert(VINNumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(VINCharset, string.char(i)) end
for i = 97, 122 do table.insert(VINCharset, string.char(i)) end

function GenerateVIN()
	local generatedVIN
	local VINdoBreak = false
	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())

		generatedVIN = string.upper(GetRandomNumber2(1) .. '' .. GetRandomLetter2(4) .. '' .. GetRandomNumber2(2) .. '' .. GetRandomLetter2(4) .. '' .. GetRandomNumber2(6))


		ESX.TriggerServerCallback('slay_pdm:checkvin', function (vin)
			if not vin then
				VINdoBreak = true
			end
		end, generatedVIN)

		if VINdoBreak then
			break
		end
	end

	return generatedVIN
end

-- mixing async with sync tasks
function IsVINTaken(vin)
	local callback			= 'waiting'

	ESX.TriggerServerCallback('slay_pdm:checkvin', function(vinumber)
		callback 		    = vinumber
	end, vin)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber2(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber2(length - 1) .. VINNumberCharset[math.random(1, #VINNumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter2(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter2(length - 1) .. VINCharset[math.random(1, #VINCharset)]
	else
		return ''
	end
end

function GenerateUUID()
	local generatedUUID
	local UUIDdoBreak = false
	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())

		generateUUID = GetRandomNumber2(4) .. '' .. GetRandomNumber2(5)
		generatedUUID = math.abs(tonumber(generateUUID))

		ESX.TriggerServerCallback('slay_pdm:checkuuid', function (uuid)
			if not uuid then
				UUIDdoBreak = true
			end
		end, generatedUUID)

		if UUIDdoBreak then
			break
		end
	end

	return generatedUUID
end

function GetVIN()
	TriggerEvent('slay_pdm:showvin')
end

function GetDecor(decorName, car)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(PlayerPedId(), true)
	local playerCar = nil
	local getDecorName = nil

	if decorName == nil then
		getDecorName = 'Vehicle_UUID'
	else
		if decorName == 'chip'then
			getDecorName = 'Vehicle_Engine_Chip'
		elseif decorName == 'uuid' then
			getDecorName = 'Vehicle_UUID'
		end
	end
	if car == nil then
		if GetVehiclePedIsIn(playerPed) ~= nil then
			playerCar = GetVehiclePedIsIn(playerPed)
		else
			ESX.Game.GetClosestVehicle(playerCoords)
		end
	else
		playerCar = car
	end
	return DecorGetInt(playerCar, getDecorName)
end


exports('GenerateUUID', GenerateUUID)
exports('GenerateVIN', GenerateVIN)
exports('GeneratePlate', GeneratePlate)
exports('GetDecor', GetDecor)
exports('GetVIN', GetVIN)