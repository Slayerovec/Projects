local playerBlipHandles = {}
local playerABlipHandles = {}
local latestBlipsUpdate = {}
local latestABlipsUpdate = {}
local eliminate = {}
local eliminateA = {}
local player_data = {}
local outin = {}
local ouAtin = {}
local cars = {}
local jobName = nil
local isDuty = nil
local adminPower = 0
local sended, sendedE = false, false
local sended2, sendedE2 = false, false
local isDead = false
local player_car = nil
local player_stop = false
local classtype = nil
local class = {
	[0] = 'car',
	[1] = 'car',
	[2] = 'car',
	[3] = 'car',
	[4] = 'car',
	[5] = 'car',
	[6] = 'car',
	[7] = 'car',
	[8] = 'motorcycle',
	[9] = 'car',
	[10] = 'car',
	[11] = 'car',
	[12] = 'car',
	[13] = 'cycle',
	[14] = 'boat',
	[15] = 'heli',
	[16] = 'plane',
	[17] = 'car',
	[18] = 'emergency',
	[19] = 'car',
	[20] = 'car',
	[21] = 'car',
	[22] = 'foot'
}

function stopBlip(id)
	if id == GetPlayerServerId(PlayerId()) then
		if not player_stop then
			player_stop = true
		else
			player_stop = true
		end
	end
end

Citizen.CreateThread(function()
	while true do
		adminPower = exports.data:getUserVar("admin")
		for index, v in each(exports.data:getCharVar("jobs")) do
			if v['duty'] then
				if Config.Emergency[jobName] then
					jobName = v['job']
					TriggerServerEvent('player_blips:onblips', jobName, player_data, player_stop, false, false)
				else
					jobName = 'plane'
				end
			else
				jobName = 'plane'
			end
		end
		Citizen.Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		player_car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if GetPedInVehicleSeat(player_car, -1) == GetPlayerPed(-1) then
			if class[GetVehicleClass(player_car)] then
				classtype = GetVehicleClass(player_car)
			end
		else
			classtype = 22
		end
		Citizen.Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if adminPower ~= 0 then
			player_data = { classtype, adminPower, isDead }
			TriggerServerEvent('player_blips:allPlayers', player_data, jobName)
		end
		Citizen.Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if not Config.Emergency[jobName] then
			if classtype == 15 or classtype == 16 then
				if not sended2 then
					serverid = GetPlayerServerId(PlayerId())
					TriggerServerEvent('player_blips:onblips', 'plane', player_data, true, false, false)
					sended = false
					sended2 = true
				end
			end
		else
			if not sended and sended2 then
				TriggerServerEvent('player_blips:onblips', 'plane', player_data, true, false, true)
				sended2 = false
				sended = true
			end
		end
		Citizen.Wait(5000)
	end
end)

RegisterNetEvent("s:statusUpdated")
AddEventHandler("s:statusUpdated", function(status)
	if status == "dead" then
		isDead = (status == "dead")
	end
	if status == "spawned" then
		adminPower = exports.data:getUserVar("admin")
		for index, v in each(exports.data:getCharVar("jobs")) do
			if v['duty'] then
				if Config.Emergency[jobName] then
					jobName = v['job']
					TriggerServerEvent('player_blips:onblips', jobName, player_data, player_stop, false, false)
				end
			end
		end
	end
end)


RegisterNetEvent("s:jobUpdated")
AddEventHandler("s:jobUpdated", function(job, grade, duty)
	for index, v in each(job) do
		if v['duty'] then
			if Config.Emergency[jobName] then
				jobName = v['job']
				TriggerServerEvent('player_blips:onblips', jobName, player_data, player_stop, false, false)
			end
		end
	end
end)

RegisterNetEvent("player_blips:elimnate")
AddEventHandler("player_blips:elimnate", function(player, admin)
	if admin then
		if adminPower > 2 then
			if latestABlipsUpdate[player] then
				eliminateA[player] = true
			end
		end
	else
		if latestBlipsUpdate[player] then
			eliminate[player] = true
		end
	end
end)

RegisterNetEvent("player_blips:offblips")
AddEventHandler("player_blips:offblips", function(admin)
	if admin then
		for index, blip in each(playerABlipHandles) do
			RemoveBlip(playerABlipHandles[index])
			playerABlipHandles[index] = nil
		end
		for index, blip in each(latestABlipsUpdate) do
			latestABlipsUpdate[index] = nil
		end
	else
		for index, blip in each(playerBlipHandles) do
			RemoveBlip(playerBlipHandles[index])
			playerBlipHandles[index] = nil
		end
		for index, blip in each(latestBlipsUpdate) do
			latestBlipsUpdate[index] = nil
		end
	end
end)

RegisterNetEvent("player_blips:updateBlips")
AddEventHandler("player_blips:updateBlips", function(blips)
	latestBlipsUpdate = blips
	cars = {}

	for index, dat in each(latestBlipsUpdate) do
		if not eliminateA[dat[1]] then
			if not dat[11] then
				if not NetworkGetEntityFromNetworkId(dat[2]) then
					dat[20] = false
					if outin[dat[1]] == nil then
						outin[dat[1]] = dat[1]
					end
				else
					if DoesEntityExist(NetworkGetEntityFromNetworkId(dat[2])) then
						dat[20] = true
					else
						dat[20] = false
						if outin[dat[1]] == nil then
							outin[dat[1]] = dat[1]
						end
					end
				end
				if dat[9] then
					cars[dat[2]] = true
				end
			else
				latestBlipsUpdate[index] = nil
			end
		else
			if latestBlipsUpdate[dat[1]] then
				RemoveBlip(playerBlipHandles[dat[1]])
				playerBlipHandles[dat[1]] = nil
				latestBlipsUpdate[dat[1]] = nil
				eliminate[dat[1]] = nil
			end
		end
	end



	for _, data in each(latestBlipsUpdate) do
		local player, jobplayer, jobother, playerName, coords = data[1], jobName, data[3], data[4], data[5]
		local dead, heading, vehType, isCar, car, hide, stop, remove  = data[6], data[7], class[data[8]], data[9], data[10], data[11], data[12], data[13]
		local cansee = nil
		local can = false


		if jobother == nil  then
			jobother = 'plane'
		end

		if jobplayer == nil  then
			jobplayer = 'plane'
		end

		if Config.Zones[jobplayer] ~= nil then
			cansee = Config.Zones[jobplayer].Blips
			if cansee ~= nil then
				for i = 1, #cansee, 1 do
					if jobother == cansee[i] then
						can = true
					end
				end
			end
		end

		--print(NetworkGetNetworkIdFromEntity(player_car))
		--print(car)

		local blip = 0
		if not stop then
			if(playerBlipHandles[player] == nil and not DoesBlipExist(playerBlipHandles[player])) then
				if data[20] then
					blip = AddBlipForEntity(NetworkGetEntityFromNetworkId(data[2]))
				else
					blip = AddBlipForCoord(coords[1], coords[2], coords[3])
				end
			else
				blip = playerBlipHandles[player]
				if data[20] then
					if DoesBlipExist(playerBlipHandles[player]) then
						for _, v in pairs(outin) do
							if v == player then
								RemoveBlip(playerBlipHandles[player])
								blip = nil
								ouAtin[player] = nil
							end
						end
					end
				else
					if DoesBlipExist(playerBlipHandles[player]) then
						SetBlipCoords(blip, coords[1], coords[2], coords[3])
					else
						blip = AddBlipForCoord(coords[1], coords[2], coords[3])
					end
				end
			end
			SetBlipRotation(blip, math.ceil(heading)) -- update rotation
		else
			if DoesBlipExist(playerBlipHandles[player]) then
				RemoveBlip(playerBlipHandles[player])
				blip = AddBlipForCoord(coords[1], coords[2], coords[3])
			else
				blip = AddBlipForCoord(coords[1], coords[2], coords[3])
			end
		end


		SetBlipAsShortRange(blip, 1)
		SetBlipAlpha(blip, 500)
		ShowHeightOnBlip(blip, true)

		if vehType == 'emergency' or vehType == 'foot' then
			SetBlipSprite(blip, Config.Markers[vehType][jobother])
		else
			SetBlipSprite(blip, Config.Markers[vehType])
		end

		SetBlipScale(blip, 0.5)
		SetBlipShrink(blip, 1)

		if isCar then
			SetBlipCategory(blip, 11)
		else
			SetBlipCategory(blip, 7)
		end

		SetBlipDisplay(blip, 6)

		if dead then
			--SetBlipFlashTimer(blip,1500)
		end

		SetBlipColour(blip, Config.BlipColors[jobother])

		--SetBlipBright(blip, true)

		playerBlipHandles[player] = blip
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(playerName)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent("player_blips:updateABlips")
AddEventHandler("player_blips:updateABlips", function(blipsA)
	latestABlipsUpdate = blipsA


	for index, dat in each(latestABlipsUpdate) do
		if not eliminateA[dat[1]] then
			if not NetworkGetEntityFromNetworkId(dat[2]) then
				dat[20] = false
				if ouAtin[dat[1]] == nil then
					ouAtin[dat[1]] = dat[1]
				end
			else
				if DoesEntityExist(NetworkGetEntityFromNetworkId(dat[2])) then
					dat[20] = true
				else
					dat[20] = false
					if ouAtin[dat[1]] == nil then
						ouAtin[dat[1]] = dat[1]
					end
				end
			end
		else
			if latestABlipsUpdate[dat[1]] then
				RemoveBlip(playerABlipHandles[dat[1]])
				playerABlipHandles[dat[1]] = nil
				latestABlipsUpdate[dat[1]] = nil
				eliminateA[dat[1]] = nil
			end
		end
	end

	for _, data in each(latestABlipsUpdate) do
		local player, net, name, coords, status, heading, admin, dead, car, job = data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10]
		status = class[status]
		local blip = 0

		if job == nil then
			job = 'plane'
		end

		--print(NetworkGetNetworkIdFromEntity(player_car))
		--print(car)

		if(playerABlipHandles[player] == nil and not DoesBlipExist(playerABlipHandles[player])) then
			if data[20] then
				blip = AddBlipForEntity(NetworkGetEntityFromNetworkId(data[2]))
			else
				blip = AddBlipForCoord(coords[1], coords[2], coords[3])
			end
		else
			blip = playerABlipHandles[player]
			if data[20] then
				if DoesBlipExist(playerABlipHandles[player]) then
					for _, v in pairs(ouAtin) do
						if v == player then
							RemoveBlip(playerABlipHandles[player])
							blip = nil
							ouAtin[player] = nil
						end
					end
				end
			else
				if DoesBlipExist(playerABlipHandles[player]) then
					SetBlipCoords(blip, coords[1], coords[2], coords[3])
				else
					blip = AddBlipForCoord(coords[1], coords[2], coords[3])
				end
			end
		end

		if status ~= 'foot' then
			ShowHeadingIndicatorOnBlip(blip, false)
		else
			ShowHeadingIndicatorOnBlip(blip, true)
		end

		SetBlipRotation(blip, math.ceil(heading)) -- update rotation
		SetBlipAsShortRange(blip, 1)
		SetBlipAlpha(blip, 500)
		ShowHeightOnBlip(blip, true)

		if status == 'emergency' or status == 'foot' then
			SetBlipSprite(blip, Config.Markers[status][job])
		else
			SetBlipSprite(blip, Config.Markers[status])
		end

		SetBlipScale(blip, 1.0)
		SetBlipShrink(blip, 1)
		SetBlipCategory(blip, 7)
		SetBlipDisplay(blip, 6)

		if dead then
			--SetBlipFlashTimer(blip,1500)
		end

		if admin > 2 then
			SetBlipColour(blip, 85)
		else
			SetBlipColour(blip, Config.BlipColors[job])
		end

		--SetBlipBright(blip, true)

		playerABlipHandles[player] = blip
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
	end
end)