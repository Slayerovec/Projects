AddEventHandler(
        "inventory:usedItem",
        function(itemName, slot, data)
            if itemName == "gsr_testkit" then
                if data.amount == nil then
                    data.amount = 5
                end
                if data.amount == nil or data.amount ~= nil then
                    data.amount = data.amount - 1
                    TriggerEvent(
                            "util:closestPlayer",
                            {
                                radius = Config.maxDistance
                            },
                            function(player)
                                if player then
                                    local menu = {
                                        main = {
                                            action = 'gsr_testkit_action',
                                            label = "Použití GSR testu",
                                            subLabel = "Zvolte, odkud budete odebírat vzorek"
                                        },
                                        submenu = getClothes(GetPlayerPed(player)),
                                        trigger = "weapons_scripts:client:gsr_test",
                                        data = {
                                            player = GetPlayerServerId(player),
                                            itemData = data,
                                            itemName = itemName,
                                            itemSlot = slot,
                                            clothes = getClothes(GetPlayerPed(player))
                                        }
                                    }
                                    createMenu(menu)
                                end
                            end
                    )
                end
            end
            if itemName == "water_cup" then
                local menu = {
                    main = {
                        action = 'water_cleanup_action',
                        label = "Umyj se zmrde",
                        subLabel = "Zvol, co si umyješ"
                    },
                    submenu = getClothes(PlayerPedId()),
                    trigger = "weapons_scripts:client:clean",
                    data = {
                        player = GetPlayerServerId(PlayerId()),
                        type = itemName,
                        clothes = getClothes(PlayerPedId())
                    }
                }
                createMenu(menu)
            end
        end
)

AddEventHandler("weapons_scripts:client:gsr_test", function(data)
    if data.itemData.amount == 5 then
        data.itemData.label = "Nerozbaleno"
    else
        data.itemData.label = "Rozbaleno"
    end
    TriggerServerEvent('inventory:removePlayerItem', data.itemName, 1, data.data, data.slot)
    TriggerServerEvent('weapons_scripts:server:giveGSR', data.itemName, 1, data.data, data.slot)
    TriggerClientEvent('weapons_scripts:server:GSR', data)
end)

AddEventHandler("weapons_scripts:client:clean", function(data)
    TriggerClientEvent('weapons_scripts:server:clean', data)
end)

RegisterNetEvent('weapons_scripts:client:shot')
AddEventHandler('weapons_scripts:client:shot', function()

end)

Citizen.CreateThread(function()
    while true do
        local sent = false
        local stop = false
        if IsPedSwimmingUnderWater(PlayerPedId()) and not sent then
            local data = {
                player = GetPlayerServerId(PlayerId()),
                type = "water"
            }
            TriggerClientEvent('weapons_scripts:server:clean', data)
            sent = true
        else
            sent = false
        end
        if IsPedFatallyInjured(PlayerPedId()) and not stop then
            ---local coords = GetEntityCoords(PlayerPedId())
            --local found, newZ = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z,false)
            --coords = vector3(coords.x,coords.y,newZ - 0.2)
            --TriggerServerEvent("weapons_scripts:server:getshot", coords, FireMode.Weapons[Active_Weapon])
            stop = true
        else
            stop = true
        end
        Citizen.Wait(200)
    end
end)

function getClothes(ped)
    local clothes = {}
    for i=4, 12 do
        if i ~= 6 or i ~= 11 then
            data = {
                number = GetNumberOfPedDrawableVariations(ped,i),
                name = Config.Clothes[i],
                powder = 0
            }
            table.insert(clothes, data)
        end
    end
    return clothes
end

function createMenu(menu)
    Citizen.CreateThread(function()
        WarMenu.CreateMenu(menu.main.action, menu.main.label, menu.main.subLabel)
        WarMenu.OpenMenu(menu.main.action)
        while true do
            if WarMenu.IsMenuOpened(menu.main.action) then
                for i=1, #menu.submenu do
                    if WarMenu.Button(menu.submenu[i].name) then
                        menu.data.selected = i
                        TriggerEvent(menu.trigger, menu.data)
                        WarMenu.CloseMenu()
                    end
                end
                WarMenu.Display()
            else
                break
            end
            Citizen.Wait(1)
        end
    end)
end