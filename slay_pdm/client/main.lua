local Categories, Vehicles, CurrentActionData, LastVehicles, PlayerData = {}, {}, {}, {}, {}
local PDM, LastZone, CurrentAction, CurrentVehicleData, CurrentSellerData, color1, color2, colorpearl, currentZoneSeller, currentZone = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
local IsInShopMenu, EnterMarker, updateVehicle  = false, false, false
local CurrentActionMsg 	= ''
local showroomactive = true
ESX = nil


--Updaty Vehicle a nasledný load
RegisterNetEvent('slay_pdm:updateCategories')
AddEventHandler('slay_pdm:updateCategories', function (categories)
    Categories   							= categories
end)

RegisterNetEvent('slay_pdm:updateVehicles')
AddEventHandler('slay_pdm:updateVehicles', function (vehicles)
    Vehicles   								= vehicles
end)

RegisterNetEvent('slay_pdm:klice')
AddEventHandler('slay_pdm:klice', function()
    TriggerServerEvent("esx_inventoryhud:getOwnerVehicle")
end)

function ToggleUI(state)
	if Config.Stats then
		if not state and isNuiVisible then
			SendNUIMessage({open = false})
			isNuiVisible = false
		end

		if state and not isNuiVisible then
			SendNUIMessage({open = true})
			isNuiVisible = true
		end
	end
end

AddEventHandler('slay_pdm:EnterMarker', function (zone, currentZoneSeller)
    local dbzone = Config.Zones[zone]
    if dbzone ~= nil then
        CurrentAction  = 'shop_menu'
        CurrentActionMsg = ''
        CurrentActionData = zone
        CurrentSellerData = currentZoneSeller
    end
end)

AddEventHandler('slay_pdm:ExitMarker', function (zone)
    if not IsInShopMenu then
       ESX.UI.Menu.CloseAll()
    end
    CurrentAction = nil
end)

AddEventHandler('slay_pdm:showroom', function (source, active)
    showroomactive = active
end)

RegisterNUICallback('disableHud', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({ open = false })
end)

function Shop(pobocka, PDM, seller, license, job, grade)
    typy = pobocka.Category
    local PedSeller = pobocka.Seller.Coords
    EnterMarker = false
    IsInShopMenu = true
    isNuiVisible = false
    local split = splitter(job, 'f')
    ToggleUI(true)
    ShopPodminky()
    InShopMenu(pobocka, seller, true)
    local number = 0
    local countuntil = 1
    ESX.UI.Menu.CloseAll()

    local vehiclesByCategory, elements, VehiclesPobocka, payment = {}, {}, {}, {}
    local firstVehicleData 	= nil

    if license then
        payment = {
            {label = 'Kreditní Kartou', value = 'card'},
            {label = 'Debetní Kartou', value = 'card'},
            {label = 'Převodem', value = 'card'},
            {label = 'Šek', value = 'card'},
            {label = 'Hotově',  value = 'cash'}
        }
    else
        table.insert(payment, {label = '<span style="color:red;">Nevlastníte potřebný řidičský průkaz</span>', value = 'close'})
    end

    if debugger ~= nil and pobocka.Type == 'fraction' then
        for i = 1, #typy, 1 do
            if pobocka.Permision == 'emergency' then
                if #split ~= 2 then
                    if typy[i] == job and grade == 'boss' then
                        typy = {[1] = job, [2] = 'shared'}
                    end
                else
                    if typy[i] == split[2] and grade == 'boss' then
                        typy = {[1] = split[2], [2] = 'shared'}
                    end
                end
            else
            	typy = {debugger}
            end
        end

        
        payment = {
        	{label = ('<span style="color:Green;">Koupit X ks na firmu</span>'), type = 'slider',  value = 1, min = 1, max = 10},
            {label = '<span style="color:Orange;">Koupit 1ks na firmu</span>', value = 'fraction'}
        }

    elseif grade == 'boss' and  pobocka.Permision == 'all' and pobocka.Type ~= 'fraction' then
        table.insert(payment, {label = ('<span style="color:red;">Koupit %s ks na firmu</span>'), type = 'slider',  value = 1, min = 1, max = 10})
        table.insert(payment, {label = '<span style="color:Orange;">Koupit 1ks na firmu</span>', value = 'fraction'})
    end

    for k,v in pairs(Vehicles) do
        if v.public == true then
            for i = 1, #typy, 1 do
                if v.category == typy[i] then
                    table.insert(VehiclesPobocka, v)
                end
            end
        end
    end

    for i = 1, #Categories, 1 do
        vehiclesByCategory[Categories[i].name]	= {}
    end

    for i = 1, #VehiclesPobocka, 1 do
        table.insert(vehiclesByCategory[VehiclesPobocka[i].category], VehiclesPobocka[i])
    end

    for i = 1, #typy, 1 do

        local category = typy[i]
        local categoryVehicles = vehiclesByCategory[category]
        local options = {}
        
	    if #VehiclesPobocka == 0 or #Vehicles == 0 then
		    ESX.UI.Menu.CloseAll()
		    EnterMarker = true
		    isNuiVisible = true
			ToggleUI(false)
            Citizen.Wait(100)
            TriggerServerEvent('slay_pdm:update')
            TriggerServerEvent('slay_pdm:selleremove', PDM, seller)
			exports.tchaj_notify:Notify('error', ('Tento prodavač Vám nic nenabízí'))
			IsInShopMenu = false
            spawn = true
			InShopMenu(pobocka, seller, spawn)
	    end

        for j = 1, #categoryVehicles, 1 do
            local vehicle = categoryVehicles[j]

            if i == 1 and j == 1 then
                firstVehicleData = vehicle

            end

            --if #typy == 1 then
			--	table.insert(elements, {label = vehicle.name, value = 0, price = ESX.Math.GroupDigits(vehicle.price), model = firstVehicleData.model})
        	--else
            	table.insert(options, ('%s<span style="color:green;">$%s</span>'):format(vehicle.name, ESX.Math.GroupDigits(vehicle.price)))
        	--end
        end


        --if #typy > 1 then
	        table.insert(elements,{
	            name = category,
	            label = category,
	            value = 0,
	            type = 'slider',
	            max = typy[i],
	            options = options,
	        })
	    --end

    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
        title 	= ('Katalog prodejny <span style="color:Orange;">%s</span>'):format(PDM),
        align 	= 'top-left',
        elements = elements
    },function(data, menu)
        local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_payment_option', {
                title = 'Platebni možnosti',
                align = 'top-left',
                elements = payment
            }, function(data2, menu2)

            	if type(data2.current.value) == 'number' then
            		countuntil = data2.current.value
           		else
           			countuntil = 1
           		end

            	if data2.current.value == 'count' then
                elseif data2.current.value ~= 'close' then
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_card_confirm', {
                        title = ('Koupit %s za <span style="color:red;">$%s</span>'):format(vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
                        align = 'top-left',
                        elements = {
                            {label = '<span style="color:red;">Ne</span>',  value = 'no'},
                            {label = '<span style="color:green;">Ano</span>', value = 'yes'}
                        }
                    }, function(data3, menu3)
                        if data3.current.value == 'yes' then
                            ESX.TriggerServerCallback('slay_pdm:pay', function(money, text)
                                if money then
                                    local vehiclemodel 			 	= vehicleData.model
                                    local foundSpawn, spawnPoint 	= SpawnPoint(pobocka)
                                    count = number
                                    fraction = false
                                    isNetwork = true
                                    success = false
                                    IsInShopMenu 				 	= false
                                    ESX.UI.Menu.CloseAll()
                                    EnterMarker 					= true
                                    DeleteInsideVehicles()

	                                if foundSpawn then
                                        carcoords = spawnPoint.coords
                                        carheading = spawnPoint.heading
                                        spawn = true
                                    else
                                        carcoords = pobocka.SpawnPoint.coords
                                        carheading = pobocka.SpawnPoint.heading
                                        spawn = false
                                    end

                                    if pobocka.Type == 'fraction' or pobocka.Type == 'boat' then
                                    	fraction = true
                                    	isNetwork = false
                                    	spawn = true
                                    elseif pobocka.Type == 'plane' then
                                        spawn = false
                                    end

                                    InShopMenu(pobocka, seller, spawn)
                                    isNuiVisible = true
  	 								ToggleUI(false)
                                    local vehicle =  CreateVehicle(vehiclemodel, carcoords, carheading, isNetwork, false)

                                    local networkId = NetworkGetNetworkIdFromEntity(vehicle)
                                    SetNetworkIdCanMigrate(networkId, true)

                                    --ESX.Game.SpawnVehicle(vehiclemodel, spawnPoint.coords, spawnPoint.heading, function(vehicle)
                                        if color1 ~= nil and color2 ~= nil and colorpearl ~= nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color1 = color1, color2 = color2, pearlescentColor = colorpearl, dirtLevel = 0.0})
                                        elseif color1 ~= nil and color2 ~= nil and colorpearl == nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color1 = color1, color2 = color2, dirtLevel = 0.0})
                                        elseif color1 ~= nil and color2 == nil and colorpearl == nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color1 = color1, dirtLevel = 0.0})
                                        elseif color1 == nil and color2 ~= nil and colorpearl == nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color2 = color2, dirtLevel = 0.0})
                                        elseif color1 == nil and color2 == nil and colorpearl ~= nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {pearlescentColor = colorpearl, dirtLevel = 0.0})
                                        elseif color1 ~= nil and color2 == nil and colorpearl ~= nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color1 = color1, pearlescentColor = colorpearl, dirtLevel = 0.0})
                                        elseif color1 == nil and color2 ~= nil and colorpearl ~= nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {color2 = color2, pearlescentColor = colorpearl, dirtLevel = 0.0})
                                        elseif color1 == nil and color2 == nil and colorpearl == nil then
                                            ESX.Game.SetVehicleProperties(vehicle, {dirtLevel = 0.0})
                                        end

                                        repeat
                                        local newPlate     	= GeneratePlate()
                                        local newVIN     	= GenerateVIN()
                                        local newUUID       = GenerateUUID()
                                        Citizen.Wait(20)
                                        SetFuel(vehicle, 100)
                                        local vehicleProps 	= ESX.Game.GetVehicleProperties(vehicle)
                                        local vehicleName  	= GetDisplayNameFromVehicleModel(vehicleData.model)
                                        SetVehicleDoorsLocked(vehicle, 2)
                                        vehicleProps.plate 	= newPlate
                                        SetVehicleNumberPlateText(vehicle, newPlate)
                                        SetVehicleOnGroundProperly(vehicle)
                                   		vehtype 			= GetVehicleClass(vehicle)
                                        vehicleProps['uuid'] = newUUID
                                        Wait(200)
                                        TriggerServerEvent('slay_pdm:owned', vehicleProps, vehicleName, vehtype, data2.current.value, job, grade, newVIN, vehicleData.name)
                                        TriggerServerEvent("esx_inventoryhud:getOwnerVehicle")
                                        TriggerServerEvent('slay_pdm:selleremove', PDM, seller)
                                        FreezeEntityPosition(PlayerPedId(), true)

                                        if countuntil ~= 1 then
	                                       	count = count + 1
											if count == countuntil then
												success = true
											end
										else
											success = true
										end

			                        	until success

                                        if spawn then
                                            StartAnim(pobocka, PDM, seller)
                                            FreezeEntityPosition(PlayerPedId(), false)
                                        elseif not spawn then
                                            FreezeEntityPosition(PlayerPedId(), false)
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end

                                        if vehtype == 14 or fraction then
                                            ESX.Game.DeleteVehicle(vehicle)
                                        end

                                        if countuntil > 1 then
                                        	exports.tchaj_notify:Notify('success', ('Zakoupil si vozidla: %s, %s krát.'):format(vehicleData.name, countuntil))
                                        else
                                        	exports.tchaj_notify:Notify('success', ('Zakoupil si vozidlo: %s'):format(vehicleData.name))
                                    	end
                                    --end)
                                else
                                    exports.tchaj_notify:Notify('error', ('Nemáš dostatek peněz %s!'):format(text))
                                end
                            end,vehicleData.model, data2.current.value, countuntil)
                        elseif data3.current.value == 'no' then
                            menu3.close()
                        end
                    end, function (data3, menu3)
                        menu3.close()
                    end)--třetí ESX.UI
                elseif data2.current.value == 'close' then
                    menu2.close()
                    InShopMenu(pobocka, seller, true)
                    TriggerServerEvent('slay_pdm:selleremove', PDM, seller)
                end
            end, function (data2, menu2)
                --EnterMarker = true
                menu2.close()
            end)--Druhé ESX.UI
    end, function (data, menu)
    	menu.close()
    	DeleteInsideVehicles()

        EnterMarker = true
        isNuiVisible = true
        IsInShopMenu = false
        ToggleUI(false)     
        TriggerServerEvent('slay_pdm:selleremove', PDM, seller)
        InShopMenu(pobocka, seller, true)
    end, function (data, menu)
    	EnterMarker = false

    	Wait(300)
    	DeleteInsideVehicles()
        local vehicleData 	= vehiclesByCategory[data.current.name][data.current.value + 1]
        WaitForVehicleToLoad(vehicleData.model)

        ESX.Game.SpawnLocalVehicle(vehicleData.model, pobocka.View.Pos, pobocka.View.Heading, function (vehicle)
            ESX.Game.SetVehicleProperties(vehicle, {dirtLevel = 0.0})
            table.insert(LastVehicles, vehicle)
            SetVehicleOnGroundProperly(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            FreezeEntityPosition(vehicle, true)
            SetModelAsNoLongerNeeded(vehicleData.model)
        end)
        Stats(true, vehicleData.name)
       --první ESX.UI
    end)
	EnterMarker = false
    IsInShopMenu = true
    DeleteInsideVehicles()
    WaitForVehicleToLoad(firstVehicleData.model)

    ESX.Game.SpawnLocalVehicle(firstVehicleData.model, pobocka.View.Pos, pobocka.View.Heading, function (vehicle)
        ESX.Game.SetVehicleProperties(vehicle, {dirtLevel = 0.0})
        table.insert(LastVehicles, vehicle)
        SetVehicleOnGroundProperly(vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        FreezeEntityPosition(vehicle, true)
        SetModelAsNoLongerNeeded(firstVehicleData.model)
    end)
    Stats(true, firstVehicleData.name)
    Citizen.Wait(100)
end

function WaitForVehicleToLoad(modelHash)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)

        BeginTextCommandBusyString('STRING')
        AddTextComponentSubstringPlayerName('Loading')
        EndTextCommandBusyString(4)

        while not HasModelLoaded(modelHash) do
            Citizen.Wait(10)
            DisableAllControlActions(0)
        end

        RemoveLoadingPrompt()
    end
end

function DeleteInsideVehicles()
    while #LastVehicles > 0 do
        local vehicle = LastVehicles[1]

        ESX.Game.DeleteVehicle(vehicle)
        table.remove(LastVehicles, 1)
    end
end

--IsInShopMenu
function InShopMenu(pobocka, seller, delta)
    local Seller = pobocka.Seller
    if IsInShopMenu then
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityVisible(PlayerPedId(), false)
        if delta then
            SetEntityCoords(PlayerPedId(), pobocka.View.Pos.x, pobocka.View.Pos.y, pobocka.View.Pos.z)
        end
        exports['kkrp_oznameni']:DoLongHudText('success', 'Klavesy: [+],[-] a [4],[6] (barvy) nebo [7],[9] (dveře)')
    end
    if not IsInShopMenu then
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityVisible(PlayerPedId(), true)
        if delta then
            SetEntityCoords(PlayerPedId(), pobocka.Enter[seller].Coord.x, pobocka.Enter[seller].Coord.y, pobocka.Enter[seller].Coord.z2)
        end
    end
end


--Shop Barva a vypnutí vystupování z vozidla
function ShopPodminky()
    randomcolor1		= 50
    randomcolor2		= 50
    Citizen.CreateThread(function()
        while IsInShopMenu do
            Citizen.Wait(1)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
            if Config.Collors then
                if IsControlJustReleased(0, 314) then
                    ra 		 	 			= 20
                    number 		 			= math.floor(randomcolor1 + ra)
                    if number >= 1 and number <= 160 then
                        randomcolor1 	 	= number
                        collor(randomcolor1, randomcolor2)
                    end
                end

                if IsControlJustReleased(0, 315) then
                    ra 		 	 			= 20
                    number 		 			= math.floor(randomcolor1 - ra)
                    if number >= 1 and number <= 160 then
                        randomcolor1 	 	= number
                        collor(randomcolor1, randomcolor2)
                    end
                end

                if IsControlJustReleased(0, 108) then
                    ra2 		 	 		= 20
                    number2 		 		= math.floor(randomcolor2 + ra2)
                    if number2 >= 1 and number2 <= 160 then
                        randomcolor2 	 	= number2
                        collor(randomcolor1, randomcolor2)
                    end
                end

                if IsControlJustReleased(0, 107) then
                    ra2 		 	 		= 20
                    number2 		 		= math.floor(randomcolor2 - ra2)
                    if number2 >= 1 and number2 <= 160 then
                        randomcolor2 	 	= number2
                        collor(randomcolor1, randomcolor2)
                    end
                end
                if IsControlJustReleased(0, 117) then
					for i=0,7 do
						SetVehicleDoorCanBreak(GetVehiclePedIsIn(PlayerPedId(), false), i, false)
						SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false), i, false, false)
					end
                end
                if IsControlJustReleased(0, 118) then
					for i=0,7 do
						SetVehicleDoorCanBreak(GetVehiclePedIsIn(PlayerPedId(), false), i, false)
						SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId(), false), i, false)
					end
                end
            end
        end
    end)
end

-- Barva
function collor(number, number2)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    color1 	= number
    color2 	= number2
    colorpearl 	= 4
    ESX.Game.SetVehicleProperties(vehicle, {
        color1 	= color1,
        color2  = color2,
        pearlescentColor = colorpearl,
        dirtLevel = 0.0
    })
end

--ESX a update z DB
Citizen.CreateThread(function ()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while updateVehicle == false do
        Citizen.Wait(5000)
        if ESX ~= nil then
            RefreshPed()
        end
        TriggerServerEvent('slay_pdm:update')
        updateVehicle = true
        break
    end

    -- 30min timer Update
    while true do
       Citizen.Wait(180000)
        TriggerServerEvent('slay_pdm:update')
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    Citizen.Wait(2000)
end)

function lengtharray(Categories)
  local count               = 0

    for _ in pairs(Categories) do
        count               = count + 1
    end

  return count
end

--Open
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if EnterMarker then
            if CurrentAction == 'shop_menu' and CurrentActionData ~= nil and IsControlJustReleased(0, 38) then
                PDM = CurrentActionData
                seller  = CurrentSellerData
                local pobocka  = Config.Zones[PDM]
                local prodejAut = pobocka.Type

                if PlayerData ~= nil and PlayerData.job ~=nil and PlayerData.job.name ~= nil then
                    job = PlayerData.job.name
                    grade = PlayerData.job.grade_name
                else
                    job = ESX.GetPlayerData().job.name
                    grade = ESX.GetPlayerData().job.grade_name
                end

                if pobocka.Seller[seller].Coords ~= nil then
                    Ped	= pobocka.Seller[seller].Coords
                    local closestPed, closestPedDst = ESX.Game.GetClosestPed(Ped)

                    if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
                        RefreshPed(true, PDM, seller)
                    end
                end

                --if job == Config.debug[job] or job == 'off'..Config.debug[job] then
                    debugger = Config.debug[job]
                --end

                if prodejAut == 'fraction' and debugger == pobocka.Permision or pobocka.Permision ~= 'emergency' then
                    --if prodejAut == 'fraction' and pobocka.Permision ~= debugger or pobocka.Permision == 'all' then
                        if prodejAut == 'fraction' and grade == 'boss' and debugger ~= nil  or prodejAut ~= 'fraction' then
                            ESX.TriggerServerCallback('slay_pdm:seller', function(status)
                                if status then
                                    if Config.license then
                                        ESX.TriggerServerCallback('slay_pdm:checkLicense', function(license)
                                            Shop(pobocka, PDM, seller, license, job, grade)
                                        end, prodejAut)
                                    else
                                        Shop(pobocka, PDM, seller, license, job, grade)
                                    end
                                else
                                    exports.tchaj_notify:Notify('error', 'Prodavač je zaneprázděný')
                                end
                            end, PDM, CurrentSellerData)
                        else
                            exports.tchaj_notify:Notify('error', 'Zde nemáte přístup!')
                        end
    --                 else
    --             	   exports.tchaj_notify:Notify('error', 'S frčkama sem nelez!')
                   -- end
                else
                    exports.tchaj_notify:Notify('error', 'Nevidím na Vašem oblečení žadné frčky.')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
local pref   = Config.Zones
    while true do
        Citizen.Wait(10)
        local coords = GetEntityCoords(PlayerPedId())
        local Zone   = currentZone
        local Seller = currentZoneSeller
        if EnterMarker then
            if Zone ~= nil and Seller ~= nil then
                if pref[Zone].Enter[Seller].Text == nil then
                    exports.djm_text3d:DrawText3D(pref[Zone].Enter[Seller].Coord.x, pref[Zone].Enter[Seller].Coord.y, pref[Zone].Enter[Seller].Coord.z, '~s~Katalog vozidel ~b~[E]~s~')
                else
                    exports.djm_text3d:DrawText3D(pref[Zone].Enter[Seller].Coord.x, pref[Zone].Enter[Seller].Coord.y, pref[Zone].Enter[Seller].Coord.z, pref[Zone].Enter[Seller].Text)
                end
            end
        end
    end
end)

-- IsIn Marker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local coords      				= GetEntityCoords(PlayerPedId(), true)
        local IsInMarker  				= false
                currentZone 			= nil
                currentZoneSeller 		= nil


        for k,v in pairs(Config.Zones) do
            for i = 1, #v.Enter do
                local chckDistance		= GetDistanceBetweenCoords(coords, v.Enter[i].Coord.x, v.Enter[i].Coord.y, v.Enter[i].Coord.z, true)

                if (chckDistance < v.Enter[i].Size.x) then
                    IsInMarker  		= true
                    currentZone 		= k
                    currentZoneSeller	= i
                end
            end
        end


        if (IsInMarker and not EnterMarker) or (IsInMarker and LastZone ~= currentZone) then
            EnterMarker					= true
            LastZone					= currentZone
            TriggerEvent('slay_pdm:EnterMarker', currentZone, currentZoneSeller)
        end

        if not IsInMarker and EnterMarker then
            EnterMarker					= false
            currentZone 				= nil
            currentZoneSeller 			= nil
            TriggerEvent('slay_pdm:ExitMarker', LastZone)
        end
    end
end)
