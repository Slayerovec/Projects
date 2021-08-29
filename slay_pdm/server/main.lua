local ESX 		 			 = nil
local Categories 			 = {}
local Vehicles   			 = {}
local vehicles 				 = {}
local Ped 					 = false

TriggerEvent('esx:getSharedObject', function(obj)
ESX = obj
end)

ESX.RegisterServerCallback("slay_pdm:pedExists", function(source, cb)
	print(Ped)
	if Ped then
		cb(true)
	else
		Ped = true
		cb(false)
	end
end)

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')	

	vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
	for i=1, #vehicles, 1 do
		local vehicle 				  = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end
		table.insert(Vehicles, vehicle)	
	end
end)

RegisterServerEvent('slay_pdm:updateuuid')
AddEventHandler('slay_pdm:updateuuid', function (plate, uuid)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate=@plate',{['@plate'] = plate}, function(result)
		if result[1] ~= nil then
			MySQL.Sync.execute('UPDATE owned_vehicles SET uuid=@uuid WHERE plate = @plate', {
				['@plate']   = plate,
				['@uuid'] = uuid
			})
		else
			MySQL.Async.fetchAll('SELECT 1 FROM company_vehicles WHERE plate=@plate',{['@plate'] = plate}, function(result)
				if result[1] ~= nil then
					MySQL.Sync.execute('UPDATE company_vehicles SET uuid=@uuid WHERE plate = @plate)', {
						['@plate']   = plate,
						['@uuid'] = uuid
					})
				end
			end)
		end
	end)
end)

RegisterServerEvent('slay_pdm:update')
AddEventHandler('slay_pdm:update', function ()
	local _source = source

	TriggerClientEvent('slay_pdm:updateVehicles', _source, vehicles)
	TriggerClientEvent('slay_pdm:updateCategories', _source, Categories)
end)

Citizen.SetTimeout(180000, function()
    -- while true do
    -- 	Citizen.Wait(180000)
	    local mt_begin = GetGameTimer()
	    -- for i = 1, #Vehicles,1,-1 do
	    -- 	table.remove(Vehicles, i)
	    -- end
	    local Vehicles = {}
	    Citizen.Wait(100)
		Categories = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')	

		vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
		for i=1, #vehicles, 1 do
			local vehicle 				  = vehicles[i]

			for j=1, #Categories, 1 do
				if Categories[j].name == vehicle.category then
					vehicle.categoryLabel = Categories[j].label
					break
				end
			end
			table.insert(Vehicles, vehicle)	
		end
	--end
end)




RegisterCommand('klice', function(source, args)
	TriggerClientEvent("slay_pdm:klice", source)
end, false)

RegisterCommand('flip', function(source, args)
	TriggerClientEvent("slay_pdm:flip", source)
end, false)

RegisterCommand('showvin', function(source, args)
	TriggerClientEvent("slay_pdm:showvin", source)
end, false)

RegisterCommand('fuel', function(source, args)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getGroup() ~= 'user' then
		data = 'admin'
	else
		data = 'user'
	end
	TriggerClientEvent("slay_pdm:fuel", source, data)
end, false)

RegisterCommand('spawncar', function(source, args)
local xPlayers = ESX.GetPlayers()
local alerted = 0
	for i=1, #xPlayers, 1 do
	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	    local playerName = GetPlayerName(source)
	    local permision = xPlayer.getGroup()
	end
	local n = podminka(args)
	if n ~= 0 and permision ~= 'user' then
    	local plate = string.upper(args[1])
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate=@plate',{['@plate'] = plate}, function(result)
			if result[1] == nil then
				MySQL.Async.fetchAll('SELECT * FROM company_vehicles WHERE plate=@plate',{['@plate'] = plate}, function(results)
					if results[1] ~= nil then
					local vehicles = results[1]
    					TriggerClientEvent("slay_pdm:spawncar", source, vehicles)
    				end
    			end)
			else
				local vehicles = result[1]
				TriggerClientEvent("slay_pdm:spawncar", source, vehicles)
    		end
    	end)
	else
	end
end, false)

RegisterServerEvent('slay_pdm:givePilotLicense')
AddEventHandler('slay_pdm:givePilotLicense',function(reciever)
	local xPlayer = ESX.GetPlayerFromId(reciever)
	local owner = xPlayer.identifier
	MySQL.Sync.execute('INSERT INTO user_licenses (owner, type) VALUES (@owner, @type)', {
		['@owner'] 	= owner,
		['@type'] 	= 'pilot_license'
	}, function (rowsChanged)
		TriggerClientEvent('kkrp_oznameni:client:SendAlert', _source, { type = 'info', text = ('Předal si letečák!') })
	end)
end)

ESX.RegisterServerCallback("slay_pdm:checkLicense", function(source, cb, prodejAut)
	local xPlayer = ESX.GetPlayerFromId(source)
	local owner = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {
		['@identifier'] 	= owner
	}, function(result)
		license 			= {
					car 	= false,
					motorcycles = false,
					truck 	= false,
					planes 	= false,
					boat 	= true,
					cycles 	= true,
					
		}

		for k,v in pairs(result) do
			if v.type == 'drive' then
				license['car'] = true
			elseif v.type == 'drive_bike' then
				license['motorcycles'] = true
			elseif v.type == 'drive_truck' then
				license['truck'] = true
			elseif v.type == 'pilot_license' then
				license['planes'] = true
			end
		end

		if license[prodejAut] == nil then
			cb(true)
		elseif license[prodejAut] then
			cb(true)
		else
			cb(false)
		end

	end)
end)

function podminka(Categories)
  local count 				= 0

  	for _ in pairs(Categories) do
  	 	count 				= count + 1
	end

  return count
end



ESX.RegisterServerCallback('slay_pdm:pay', function(source, cb, vehicleModel, option, number)
	local xPlayer     				= ESX.GetPlayerFromId(source)
	local vehicleData 				= nil

	if type(option) == 'number' then
		option = 'fraction'
	end

	for i = 1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end
	if option == 'card' then
		if xPlayer.getAccount('bank').money >= vehicleData.price then
			xPlayer.removeAccountMoney('bank', vehicleData.price)
			cb(true, 'osobní')
		else

			cb(false, 'v bance')
		end
	elseif option == 'cash' then
		if xPlayer.getMoney() >= vehicleData.price then
			xPlayer.removeMoney(vehicleData.price)
			cb(true, 'osobní')
		else
			cb(false, 'u sebe')
		end
	elseif option == 'fraction' then
		TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
			price = math.floor(number * vehicleData.price)
			if society ~= nil then
				TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
					if account.money >= price then
						account.removeMoney(price)
						cb(true, 'firemní')
					else
						cb(false, 'na firemním účtě')
					end
				end)
			else
				cb(false, 'error')
			end
		end)
	end
end)

RegisterServerEvent('slay_pdm:owned')
AddEventHandler('slay_pdm:owned', function (vehicleProps, vehicleName, vehtype, company, job, grade, newVIN, vehicleLabelName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if type(company) == 'number' then
		company = 'fraction'
	end
	if vehtype == 14 then
		vehicletype = 'boat'
	elseif vehtype == 15 or vehtype == 16 then
		vehicletype = 'plane'
	else
		vehicletype = 'car'
	end

	if company == 'fraction' then
		MySQL.Sync.execute('INSERT INTO company_vehicles (vin, plate, job, grades, vehicle, vehicleName, state, type, vehicleRename, uuid) VALUES (@vin, @plate, @job, @grades, @vehicle, @name, @state, @type, @vehicleRename, @uuid)', {
			['@vin']   	 = newVIN,
			['@plate']   = vehicleProps.plate,
			['@job']     = job,
			['@grades']  = '[]',
			['@vehicle'] = json.encode(vehicleProps),
			['@name'] 	 = vehicleName,
			['@vehicleRename'] = vehicleLabelName,
			['@state'] 	 = 1,
			['@type'] 	 = vehicletype,
			['@uuid'] = vehicleProps['uuid']

		}, function (rowsChanged)
			TriggerClientEvent('kkrp_oznameni:client:SendAlert', _source, { type = 'info', text = ('SPZ firemního vozidla je %s'):format(vehicleProps.plate) })
		end)
	else
		MySQL.Sync.execute('INSERT INTO owned_vehicles (owner, vin, plate, vehicle, type, vehicleName, state, vehicleRename, uuid) VALUES (@owner, @vin, @plate, @vehicle, @type, @name, @state, @vehicleRename, @uuid)', {
			['@owner']   = xPlayer.identifier,
			['@vin']   	 = newVIN,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@type'] 	 = vehicletype,
			['@name'] 	 = vehicleName,
			['@vehicleRename'] = vehicleLabelName,
			['@state']   = 1,
			['@uuid'] = vehicleProps['uuid']
		}, function (rowsChanged)
			TriggerClientEvent('kkrp_oznameni:client:SendAlert', _source, { type = 'info', text = ('SPZ vozidla je %s'):format(vehicleProps.plate) })
		end)
	end
end)

ESX.RegisterServerCallback('slay_pdm:checkspz', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] 	= plate
	}, function (result)
		if result[1] == nil then
			MySQL.Async.fetchAll('SELECT 1 FROM company_vehicles WHERE plate = @plate', {
				['@plate'] 	= plate
			}, function (result)
				cb(result[1] ~= nil)
			end)
		end
	end)
end)

ESX.RegisterServerCallback('slay_pdm:checkvin', function (source, cb, vin)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE vin=@vin LIMIT 1', {
		['@vin'] = vin,
	}, function (results)
		if results ~= nil and results[1] ~= nil then
			cb(true)
		else
			MySQL.Async.fetchAll('SELECT 1 FROM company_vehicles WHERE vin=@vin LIMIT 1', {
				['@vin'] = vin,
			}, function(results2)
				if results2 ~= nil and results2[1] ~= nil then
					cb(true)
				else
					cb(false)
				end
			end)
		end
	end)
end)

ESX.RegisterServerCallback('slay_pdm:checkuuid', function (source, cb, uuid)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE uuid=@uuid LIMIT 1', {
		['@uuid'] = uuid,
	}, function (results)
		if results ~= nil and results[1] ~= nil then
			cb(true)
		else
			MySQL.Async.fetchAll('SELECT 1 FROM company_vehicles WHERE uuid=@uuid LIMIT 1', {
				['@uuid'] = uuid,
			}, function(results2)
				if results2 ~= nil and results2[1] ~= nil then
					cb(true)
				else
					cb(false)
				end
			end)
		end
	end)
end)

--------------------------------------------------------ShowrROOM-----------------------------
local usecars 							= {}
ESX.RegisterServerCallback('slay_pdm:showroom', function (source, cb, cars, pdmka)
	local number 						= nil
	local length 	   				   	= podminka(usecars)

	if type(length) == 'number' and length == 0 then
		table.insert(usecars, cars)
	end

	car = usecars[1]

	cb(car)
end)

RegisterServerEvent('slay_pdm:showroomcars')
AddEventHandler('slay_pdm:showroomcars', function (savecars)
	print(ESX.DumpTable(savecars))
end)

---------------------------------------------------------------- SELLER --------------------------------------------------
local usedsellers = {}
table.insert(usedsellers, Config.Zones)
ESX.RegisterServerCallback('slay_pdm:seller', function(source, cb, PDM, CurrentSellerData)
	if usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] ~= 'infinite' then 
		if usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] == false then
			cb(true)
			usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] = true
		else
			cb(false)
		end
	else
		cb(true)
	end
end)

RegisterServerEvent('slay_pdm:selleremove')
AddEventHandler('slay_pdm:selleremove', function (PDM, CurrentSellerData)
	if usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] ~= 'infinite' then
		if usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] == true then
			usedsellers[1][PDM]['Enter'][CurrentSellerData]['Status'] = false
		end
	end
end)

---------------------------------------------- STEAL PLATE ----------------------------------------
RegisterServerEvent('slay_pdm:getPlate')
AddEventHandler('slay_pdm:getPlate', function (plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM spz WHERE plate = @plate AND identifier = @identifier', {
		['@plate'] 	= plate,
		['@identifier'] 	= xPlayer.identifier
	}, function (result)
		if result[1] == nil then
			MySQL.Sync.execute('INSERT INTO spz (identifier, plate) VALUES (@identifier, @spz)', {
				['@identifier']   = xPlayer.identifier,
				['@spz']   = plate,
			}, function (rowsChanged)
			end)
		else
			TriggerClientEvent('kkrp_oznameni:client:SendAlert', _source, { type = 'info', text = ('Tuhle SPZ už máš!: %s'):format(plate)})
		end
	end)
end)


ESX.RegisterServerCallback('slay_pdm:checkvehicle', function(source, cb, plates)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if Config.PlayersPlate == false then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] 	= plates
		}, function (result)
			if result[1] == nil then
				MySQL.Async.fetchAll('SELECT * FROM company_vehicles WHERE plate = @plate', {
					['@plate'] 	= plates
				}, function (results)
					if result[1] ~= nil then
						if result[1].owner == xPlayer.identifier then
							cb(true)
						else
							cb(false)
						end
					elseif results[1] ~= nil then
						if results[1].job == xPlayer.job.name then
							cb(true)
						else
							cb(false)
						end
					else
						cb(true)
					end
				end)
			else
				cb(true)
			end
		end)
	else
		cb(true)
	end
end)


RegisterServerEvent('slay_pdm:checkgetPlate')
AddEventHandler('slay_pdm:checkgetPlate', function (plate, vehicle)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM spz WHERE plate = @plate AND identifier = @identifier', {
		['@plate'] 			= plate,
		['@identifier'] 	= xPlayer.identifier
	}, function (result)
		if result[1] == nil then
			TriggerClientEvent("slay_pdm:plate", _source, plate, true, vehicle)
			TriggerClientEvent("slay_pdm:setplate", -1, plate, 'set', vehicle)
		else
			TriggerClientEvent("slay_pdm:plate", _source, plate, false, vehicle)
		end
	end)
end)

ESX.RegisterUsableItem('screwdriverplate', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local canUse = false

    if xPlayer.getInventoryItem('screwdriverplate').count >= 1 then
    	--xPlayer.addInventoryItem('plate', 1)
        TriggerClientEvent("slay_pdm:platenil", _source)
        canUse = true
    end
end)

RegisterServerEvent('slay_pdm:checkuseplate')
AddEventHandler('slay_pdm:checkuseplate', function (source, plate)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent("slay_pdm:checkuseplate", _source, plate)
end)

RegisterServerEvent('slay_pdm:useplate')
AddEventHandler('slay_pdm:useplate', function (plate, vehicle)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent("slay_pdm:setplate", -1, plate, 'reset', vehicle)
    TriggerClientEvent("esx_inventoryhud:usedplate", _source)
	MySQL.Sync.execute('DELETE FROM spz WHERE plate = @plate AND identifier = @identifier', {
		['@plate'] = plate,
		['@identifier'] = xPlayer.identifier,
	}, function (rowsChanged)
	end)
end)

RegisterServerEvent('slay_pdm:delPlate')
AddEventHandler('slay_pdm:delPlate', function (plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('kkrp_oznameni:client:SendAlert', _source, { type = 'info', text = ('Zahodil si SPZ: %s'):format(plate)})
	MySQL.Sync.execute('DELETE FROM spz WHERE plate = @plate AND identifier = @identifier', {
		['@plate'] 			= plate,
		['@identifier'] 	= xPlayer.identifier
	}, function (result)
	end)
end)

---------------------------------------------------- VIN --------------------------------------------------------------------

ESX.RegisterServerCallback('slay_pdm:vin', function (source, cb, uuid)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE uuid = @uuid', {
		['@uuid'] 	= uuid
	}, function (result)
		if result ~= nil or result[1] ~= nil then
			if result[1].vin ~= 'x' then
				cb(result[1].vin)
			else
				MySQL.Async.fetchAll('SELECT * FROM company_vehicles WHERE uuid = @uuid', {
					['@uuid'] 	= uuid
				}, function (results)
					if results ~= nil and results[1] ~= nil then
						if results[1].vin ~= 'x' then
							cb(results[1].vin)
						else
							cb(false)
						end
					end
				end)
			end
		end
	end)
end)
