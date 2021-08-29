RegisterNetEvent("slay_pdm:menu")
AddEventHandler("slay_pdm:menu", function(stat, status)
	local vehicleclass = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1)))
	properties = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	fuel = properties['fuelLevel']

	if stat == 'EMS' or stat == 'marshal' or stat == 'police' or stat == 'FD' then
		if vehicleclass == 15 or vehicleclass == 16 then
			OpenPlaneMenu(status)
		else
			OpenStateTuningMenu(stat, vehicleclass, fuel)
		end
	elseif stat == 'public' then
		if vehicleclass == 15 or vehicleclass == 16 then
			OpenPlaneMenu(status)
		else
			Extras(fuel, vehicleclass)
		end
	end
end)


function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, '_FUEL_LEVEL', GetVehicleFuelLevel(vehicle))
	end
end

function OpenStateTuningMenu(stat, vehicleclass, fuel)
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local ExtrasAvailable = false
	local elements 	= {}

	table.insert(elements, { label = 'Extras', value = 'extras' })
	if stat == 'police' then
		table.insert(elements, { label = 'Barvy',  value = 'colors' })
	elseif stat == 'marshal' then
		table.insert(elements, { label = 'Barvy',  value = 'colorm' })
	end

	table.insert(elements, { label = 'Livery',  value = 'livery' })

	if vehicleclass == 16 or vehicleclass == 15 or vehicleclass == 14 then 
		table.insert(elements, { label = 'Tankování',  value = 'fuel' })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_tuning', {
		title    = 'Garáž Úprava vozidel',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		local extras 	= {}
		FreezeEntityPosition(vehicle, true)
		if data.current.value == 'extras' then
			for id=0, 14 do
				local kekw = DoesExtraExist(vehicle, id)
				if DoesExtraExist(vehicle, id) then
					local state = IsVehicleExtraTurnedOn(vehicle, id)
					if state then
						table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:green;">Aktivní</span>', value = id, state = not state})
					else
						table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:red;">Neaktivní</span>', value = id, state = not state})
					end
					ExtrasAvailable = true
				end
			end
				if ExtrasAvailable then
	                local damages = {
	                    ['body_health'] = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
	                    ['engine_health'] = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1)
	                }
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_extras_tuning', {
						title    = 'Extras',
						align    = 'top-right',
						elements = extras
					}, function(data2, menu2)
						SetVehicleExtra(vehicle, data2.current.value, not data2.current.state)
						local new = data2.current
						if data2.current.state then
							states = '<span style="color:green;">Aktivní</span>'
							new.label  = 'Extras' .. data2.current.value .. ' ' .. states
						else
							states = '<span style="color:red;">Neaktivní</span>'
							new.label  = 'Extras' .. data2.current.value .. ' ' .. states
						end
						SetFuel(vehicle, fuel)
						new.state = not data2.current.state
						exports['kkrp_oznameni']:DoLongHudText('success', ( 'Extras'..data2.current.value .. ' změněn!'))
						menu2.update({value = data2.current.value}, new)
						menu2.refresh()
						setDamages(vehicle, damages)
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					exports["tchaj_notify"]:Notify('error', ('Toto vozidlo nemá žadný extras!'))
				end
		elseif data.current.value == 'colors' then
					local colors = {
						{label = 'Černá', 			value = 0},
						{label = 'Matně Černá', 	value = 12},
						{label = 'Bílá', 			value = 111},
						{label = 'Matně Bílá', 		value = 121},
						{label = 'Modrá', 			value = 62},
						{label = 'Creme', 			value = 107},
						{label = 'Stříbrná', 		value = 4},
						{label = 'Šedá', 		    value = 14},
						{label = 'Červená', 		value = 27},
						{label = 'Oranžová', 		value = 38},
					}
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_colors_tuning', {
					title    = 'Garáž - Lakovna',
					align    = 'top-right',
					elements = colors
				}, function(data2, menu2)
				ESX.Game.SetVehicleProperties(vehicle, {
					color1 = data2.current.value,
					color2 = data2.current.value,
				})
				SetFuel(vehicle, fuel)
				exports["tchaj_notify"]:Notify('success', ('Barva změněna!'))
				end, function(data2, menu2)
					menu2.close()
				end)
		elseif data.current.value == 'fuel' then
			SetFuel(vehicle, 100)
		elseif data.current.value == 'colorm' then
			local colors = {
				{label = 'Černá', 			value = 0},
				{label = 'Bílá', 			value = 111},
				{label = 'Matně Bílá', 		value = 121},
				{label = 'Creme', 			value = 107},
				{label = 'Stříbrná', 		value = 4},
				{label = 'Šedá', 		    value = 14},
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_colors_tuning', {
				title    = 'Garáž - Lakovna',
				align    = 'top-right',
				elements = colors
			}, function(data2, menu2)
			ESX.Game.SetVehicleProperties(vehicle, {
				color1 = data2.current.value,
				color2 = data2.current.value,
			})
			SetFuel(vehicle, fuel)
			exports["tchaj_notify"]:Notify('success', ('Barva změněna!'))
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'livery' then
		local livery = {}
		
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
		local liveryCount = GetVehicleLiveryCount(vehicle)
				
		for i = 1, liveryCount do
			local state = GetVehicleLivery(vehicle) 
			
			if state == i then
				table.insert(livery, {label = 'Livery' .. i .. ' ' .. '<span style="color:green;">Aktivní</span>', value = i, state = not state})
			else
				table.insert(livery, {label = 'Livery' .. i .. ' ' .. '<span style="color:red;">Neaktivní</span>', value = i, state = not state})
			end
		end
			if #livery > 0 then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
					title    = 'Livery Menu',
					align    = 'top-left',
					elements = livery
				}, function(data2, menu2)
					SetVehicleLivery(vehicle, data2.current.value, not data2.current.state)
					local new = data2.current
					if data2.current.state then
						states = '<span style="color:green;">Aktivní</span>'
						new.label  = 'Livery' .. data2.current.value .. ' ' .. states
					else
						states = '<span style="color:red;">Neaktivní</span>'
						new.label  = 'Livery' .. data2.current.value .. ' ' .. states
					end
					new.state = not data2.current.state
					SetFuel(vehicle, fuel)
					exports['kkrp_oznameni']:DoLongHudText('success', ( 'Livery'..data2.current.value .. ' změněn!'))
					menu2.update({value = data2.current.value}, new)
					menu2.refresh()
					menu2.close()
					end, function(data2, menu2)
					menu2.close()		
					end)
			else
				exports["tchaj_notify"]:Notify('error', ('Toto vozidlo nemá žadný Livery!'))
			end
		end
	end, function(data, menu)
		menu.close()
		FreezeEntityPosition(vehicle, false)
	end)
end



function Extras(fuel, vehicleclass)
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local ExtrasAvailable = false
	local elements 	= {}

	table.insert(elements, { label = 'Extras', value = 'extras' })

	if vehicleclass == 16 or vehicleclass == 15 or vehicleclass == 14 then 
		table.insert(elements, { label = 'Tankování',  value = 'fuel' })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_tuning', {
		title    = 'Garáž Úprava vozidel',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
	if data.current.value == 'extras' then
		local extras 	= {}
		FreezeEntityPosition(vehicle, true)
			for id=0, 14 do
				if DoesExtraExist(vehicle, id) then
					local state = IsVehicleExtraTurnedOn(vehicle, id)
					if state then
						table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:green;">Aktivní</span>', value = id, state = not state})
					else
						table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:red;">Neaktivní</span>', value = id, state = not state})
					end
					ExtrasAvailable = true
				end
			end
			if ExtrasAvailable then
                local damages = {
                    ['body_health'] = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
                    ['engine_health'] = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1)
                }
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_extras_tuning', {
					title    = 'Extras',
					align    = 'top-right',
					elements = extras
				}, function(data2, menu2)
					SetVehicleExtra(vehicle, data2.current.value, not data2.current.state)
					local new = data2.current
					if data2.current.state then
						states = '<span style="color:green;">Aktivní</span>'
						new.label  = 'Extras' .. data2.current.value .. ' ' .. states
					else
						states = '<span style="color:red;">Neaktivní</span>'
						new.label  = 'Extras' .. data2.current.value .. ' ' .. states
					end
					SetFuel(vehicle, fuel)
					setDamages(car, damages)
					new.state = not data2.current.state
					exports['kkrp_oznameni']:DoLongHudText('success', ( 'Extras'..data2.current.value .. ' změněn!'))
					menu2.update({value = data2.current.value}, new)
					menu2.refresh()
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				exports["tchaj_notify"]:Notify('msg', ('Toto vozidlo nemá žadný extras!'))
			end
		elseif data.current.value == 'fuel' then
			SetFuel(vehicle, 100)
		end
	end, function(data, menu)
		menu.close()
		FreezeEntityPosition(vehicle, false)
	end)
end


function OpenPlaneMenu(status)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local vehicleclass = GetVehicleClass(vehicle)
    local ExtrasAvailable = false
    local elements  = {
        { label = 'Extras', value = 'extras' },
        { label = 'Livery',  value = 'livery' },
        { label = 'Tankování',  value = 'fuel' },
        { label = 'Despawn',  value = 'delete' },
    }
    if status then
        table.insert(elements, { label = 'Barvy',  value = 'colors' })
    end
    if vehicleclass == 15 or vehicleclass == 16 then
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_tuning', {
        title    = 'Garáž Úprava vozidel',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        local extras    = {}
        FreezeEntityPosition(vehicle, true)
        if data.current.value == 'extras' then
            for id=0, 14 do
                local kekw = DoesExtraExist(vehicle, id)
                if DoesExtraExist(vehicle, id) then
                    local state = IsVehicleExtraTurnedOn(vehicle, id)
                    if state then
                        table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:green;">Aktivní</span>', value = id, state = not state})
                    else
                        table.insert(extras, {label = 'Extras' .. id .. ' ' .. '<span style="color:red;">Neaktivní</span>', value = id, state = not state})
                    end
                    ExtrasAvailable = true
                end
            end
                if ExtrasAvailable then
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_extras_tuning', {
                        title    = 'Extras',
                        align    = 'top-right',
                        elements = extras
                    }, function(data2, menu2)
                        SetVehicleExtra(vehicle, data2.current.value, not data2.current.state)
                        local new = data2.current
                        if data2.current.state then
                            states = '<span style="color:green;">Aktivní</span>'
                            new.label  = 'Extras' .. data2.current.value .. ' ' .. states
                        else
                            states = '<span style="color:red;">Neaktivní</span>'
                            new.label  = 'Extras' .. data2.current.value .. ' ' .. states
                        end
                        new.state = not data2.current.state
                        exports['kkrp_oznameni']:DoLongHudText('success', ( 'Extras'..data2.current.value .. ' změněn!'))
                        menu2.update({value = data2.current.value}, new)
                        menu2.refresh()
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                else
                    exports["tchaj_notify"]:Notify('error', ('Toto vozidlo nemá žadný extras!'))
                end
        elseif data.current.value == 'colors' then
            local colors = {
            }
            for i=1, 160 do
                table.insert(colors, {label = 'Barva#'..i, value = i})
            end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_colors_tuning', {
            title    = 'Garáž - Lakovna',
            align    = 'top-right',
            elements = colors
        }, function(data2, menu2)
        ESX.Game.SetVehicleProperties(vehicle, {
            color1 = data2.current.value,
            color2 = data2.current.value,
        })
        exports['kkrp_oznameni']:DoLongHudText('success', ('Barva změněna!'))
        end, function(data2, menu2)
            menu2.close()
        end)
    elseif data.current.value == 'fuel' then
        SetFuel(vehicle, 100)
		elseif data.current.value == 'livery' then
		local livery = {}
		
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
		local liveryCount = GetVehicleLiveryCount(vehicle)
				
		for i = 1, liveryCount do
			local state = GetVehicleLivery(vehicle) 
			
			if state == i then
				table.insert(livery, {label = 'Livery' .. i .. ' ' .. '<span style="color:green;">Aktivní</span>', value = i, state = not state})
			else
				table.insert(livery, {label = 'Livery' .. i .. ' ' .. '<span style="color:red;">Neaktivní</span>', value = i, state = not state})
			end
		end
			if #livery > 0 then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
					title    = 'Livery Menu',
					align    = 'top-left',
					elements = livery
				}, function(data2, menu2)
					SetVehicleLivery(vehicle, data2.current.value, not data2.current.state)
					local new = data2.current
					if data2.current.state then
						states = '<span style="color:green;">Aktivní</span>'
						new.label  = 'Livery' .. data2.current.value .. ' ' .. states
					else
						states = '<span style="color:red;">Neaktivní</span>'
						new.label  = 'Livery' .. data2.current.value .. ' ' .. states
					end
					new.state = not data2.current.state
					SetFuel(vehicle, fuel)
					exports['kkrp_oznameni']:DoLongHudText('success', ( 'Livery'..data2.current.value .. ' změněn!'))
					menu2.update({value = data2.current.value}, new)
					menu2.refresh()
					menu2.close()
					end, function(data2, menu2)
					menu2.close()		
					end)
			else
				exports["tchaj_notify"]:Notify('error', ('Toto vozidlo nemá žadný Livery!'))
			end
    elseif data.current.value == 'delete' then
        ESX.Game.DeleteVehicle(vehicle)
        end
    end, function(data, menu)
        menu.close()
        FreezeEntityPosition(vehicle, false)
    end)
    else 
        exports["tchaj_notify"]:Notify('error', ('Tohle vozidle nemůžete upravovat!'))
    end
end

RegisterNetEvent('slay_pdm:fuel')
AddEventHandler('slay_pdm:fuel', function(data)
local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
local vehicleclass = GetVehicleClass(vehicle)
	if vehicleclass == 14 or data == 'admin' then
		SetFuel(vehicle, 100)
	end
end)

RegisterNetEvent('slay_pdm:spawncar')
AddEventHandler('slay_pdm:spawncar', function(info)
    local model = json.decode(info.vehicle).model
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local car = CreateVehicle(model, GetEntityCoords(PlayerPedId(-1)), 90, true, true)

    local vehicleConfiguration = json.decode(info.vehicle)

    ESX.Game.SetVehicleProperties(car, vehicleConfiguration)
    if info.damages ~= nil then 
    	setDamages(car, json.decode(info.damages))
    end
    SetFuel(car, 100)

    while not NetworkGetEntityIsNetworked(car) do
		NetworkRegisterEntityAsNetworked(car)
		Wait(0)
    end

    SetEntityAsMissionEntity(car, true, true)
    SetVehicleHasBeenOwnedByPlayer(car, true)
    SetVehicleNeedsToBeHotwired(car, false)
    SetVehRadioStation(car, 'OFF')
    TaskWarpPedIntoVehicle(PlayerPedId(-1), car, -1)
end)

setDamages = function(car, damages)
    for i = 0, 13 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                --SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
        if damages['broken_doors'] then
            if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
    end

    if damages['body_health'] then
        SetVehicleBodyHealth(car, damages['body_health'])
    end
    if damages['engine_health'] then
        SetVehicleEngineHealth(car, damages['engine_health'])
    end
end
