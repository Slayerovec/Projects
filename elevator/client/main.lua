local TE, TCE, TSE, RNE, RSE, AEH, CCT, SNM, RNC = TriggerEvent, TriggerClientEvent, TriggerServerEvent, RegisterNetEvent, RegisterServerEvent, AddEventHandler, Citizen.CreateThread, SendNUIMessage, RegisterNUICallback
local elevators = Config.Elevators
local is_near_elevator = false
local is_near_building = false
local is_near_floor = false
local is_panel_open = false
local isShowingHint = false
local ele_way = nil
local current_elevator_data = nil
local floor = nil
local building = nil

Keys = {
 ["1"]         = 157,  ["2"]         = 158,  ["3"]         = 160,
 ["4"]        = 108,  ["5"]        = 60,   ["6"]        = 107,  ["7"]  = 117,  ["8"]  = 61,   ["9"]  = 118
}

RNE('elevator:ElevatorData')
AEH('elevator:ElevatorData', function(data)
    current_elevator_data = data
end)

RNE('elevator:going')
AEH('elevator:going', function(floore)
    if is_near_elevator then
        playEleMusic()
        DoTeleport(current_elevator_data.floors[floore])
        closeMenu()
    end
end)

function DoTeleport(coords)
    closeMenu()
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    DoScreenFadeOut(100)
    Citizen.Wait(10000)
    teleport(PlayerPedId(), coords)
    DoScreenFadeIn(100)
    NetworkFadeInEntity(PlayerPedId(), false)
end

function teleport(entity, coords)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    while not HasCollisionLoadedAroundEntity(entity) do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Citizen.Wait(0)
    end

    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    TSE('elevator:ende', building)
    is_near_elevator = false
    is_near_building = false
    is_near_floor = false
    is_panel_open = false
    isShowingHint = false
    ele_way = nil
    current_elevator_data = nil
    floor = nil
    building = nil
end

function playEleMusic()

    SNM({
        transactionType     = 'playSound',
        transactionFile     = 'elevator',
        transactionVolume   = 0.15
    })

end

function openMenu()
    if current_elevator_data ~= nil then
        is_panel_open = true
        SNM({
            transactionType     = 'show',
            current_floor       = floor,
            current_elevator_floor = current_elevator_data.current_floor
        })
    end
end

function closeMenu()
    is_panel_open = false
    SNM({
        transactionType     = 'hide'
    })
end

function call(number)
    if number <= #current_elevator_data.floors then
        ele_way = number
        SNM({
            transactionType     = 'call',
            current_floor       = number
        })
        if current_elevator_data.current_floor ~= floor then
            TSE('elevator:call', building, ele_way)
        else
            TSE('elevator:request', building, ele_way)
        end
    end
end

CCT(function()
    while true do
        Citizen.Wait(0)
        if building == nil then
            for k, data in pairs(elevators) do
                for i = 1, #data.floors do
                    local distanceEnter = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), data.floors[i].x, data.floors[i].y, data.floors[i].z, true)

                    if distanceEnter <= Config.DistanceRender then
                        is_near_building = true
                        building = k
                        Citizen.Wait(1000)
                    end

                    Citizen.Wait(200)
                end
                Citizen.Wait(50)
            end
        end
    end
end)

CCT(function()
    while true do
        Citizen.Wait(200)
        if building ~= nil then
            for i = 1, #elevators[building].floors do
                local distanceEnter = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), elevators[building].floors[i].x, elevators[building].floors[i].y, elevators[building].floors[i].z, true)

                if distanceEnter <= Config.DistanceFloor then
                    is_near_floor = true
                    floor = i
                    TSE('elevator:nearByPlayers', building, i)
                    Citizen.Wait(1000)
                end

            end
        end
    end
end)

CCT(function()
    while true do
        Citizen.Wait(200)
        if building ~= nil and floor ~= nil and current_elevator_data ~= nil then
            local distanceEnter = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), elevators[building].floors[floor].x, elevators[building].floors[floor].y, elevators[building].floors[floor].z, true)

            if distanceEnter <= Config.DistanceAction then
                is_near_elevator = true
                if current_elevator_data.current_floor == floor then
                    if not isShowingHint then
                        isShowingHint = true
                        --exports["key_hints"]:displayHint({["name"] = "drop_hint", ["key"] = "~INPUT_E53EDE83~", ["text"] = string.format('Nastoupit do výtahu')})
                    end
                end
                Citizen.Wait(1000)
            else
                isShowingHint = false
                closeMenu()
            end
        end
    end
end)

CCT(function()
    while true do
        Citizen.Wait(500)
        if building ~= nil and floor ~= nil and current_elevator_data ~= nil then
            SNM({
                transactionType     = 'change_number',
                current_floor       = floor,
                current_elevator_floor = current_elevator_data.current_floor
            })
            SNM({
                transactionType     = 'change_number',
                current_floor       = floor,
                current_elevator_floor = current_elevator_data.current_floor
            })
        end
    end
end)

--RegisterCommand("GoInElevator", function()
--    if isShowingHint then
--
--    end
--end,false)

CCT(function()
    while true do
        if isShowingHint then
            if IsControlJustPressed(0, 47) then
                if ele_way ~= nil then
                    closeMenu()
                    TSE('elevator:request', building, ele_way)
                else
                    openMenu()
                end
            end
        end
        if is_near_elevator then
            if IsControlJustPressed(0, 38) and not isShowingHint then
                if not is_panel_open then
                    openMenu()
                else
                    closeMenu()
                end
            end

            if is_panel_open then
                if IsControlJustPressed(0, 157) then
                    call(1)
                end
                if IsControlJustPressed(0, 158) then
                    call(2)
                end
                if IsControlJustPressed(0, 160) then
                    call(3)
                end
                if IsControlJustPressed(0, 108) then
                    call(4)
                end
                if IsControlJustPressed(0, 60) then
                    call(5)
                end
                if IsControlJustPressed(0, 107) then
                    call(6)
                end
                if IsControlJustPressed(0, 117) then
                    call(7)
                end
                if IsControlJustPressed(0, 61) then
                    call(8)
                end
                if IsControlJustPressed(0, 118) then
                    call(9)
                end
            end
        end
        Citizen.Wait(8)
    end
end)
--RegisterKeyMapping("GoInElevator", string.format("Nastoupit do výtahu"), "keyboard", "G")