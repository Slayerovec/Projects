local second = 100
local updateSpacing = 200
local updateIntervals = {
    [256]   = second * 15,       -- once every 5 seconds | during 256-1024 players
    [128]   = second * 10,       -- once every 4 seconds | during 128-256 players
    [96]    = second * 5,       -- once every 3 seconds | during 96-128 players
    [64]    = second,           -- once every 2 seconds | during 64-96 players
    [0]     = second            -- once every second    | during 0-64 players
}
local players = {}
local admins = {}
local allplayers = {}
local lastBlipsUpdate = {}
local lastABlipsUpdate = {}
local threadTimeWarnings = true
local mainThreadTimeThreshold = 5         -- parent thread
local updateThreadTimeThreshold = 5        -- blip updates thread
local lastIntervalValue = 0
local lastAIntervalValue = 0

function math.clamp(low, n, high)
    return math.min(math.max(n, low), high)
end

-- emitted when a player leaves the server
AddEventHandler("playerDropped", function()
    local admin = false
    if players[source] then
        players[source] = nil --[9] = true
    end
    if allplayers[source] then
        allplayers[source] = nil--[7] = true
    end
    if admins[source] then
        admins[source] = nil--[2] = true
        admin = true
    end
    TriggerClientEvent("player_blips:elimnate", -1, source, admin)
end)

RegisterNetEvent('player_blips:allPlayers')
AddEventHandler('player_blips:allPlayers', function(player_data, job)
    allplayers[source] = { player_data[1],  player_data[2], player_data[3], player_data[4], job}
end)


RegisterNetEvent('player_blips:car')
AddEventHandler('player_blips:car', function(job, stop, vehicleType, remove)
    addVeh(source, job, stop, vehicleType, remove)
end)

RegisterServerEvent('player_blips:onblips')
AddEventHandler('player_blips:onblips', function(serverid, job, player_data, hide, stop, remove)
    local isCar = false
    local data = {serverid, job, player_data[3], player_data[1], isCar, hide, stop, remove}
    players[serverid] = data
end)


RegisterCommand('adminblip', function(source, args)
    addAdmin(source)
end, false)

function addAdmin(source)
    if admins[source] then
        admins[source][2] = true
    else
        if exports.data:getUserVar(source, "admin") >= 2 then
            admins[source] = { source, false }
        end
    end
end


function addVeh(serverid, job, stop, vehicleType, remove)
    local car, dead, isCar = nil, false, false
    local playerPed = GetPlayerPed(serverid)
    local data = {}
    local success = false

    repeat
        if GetVehiclePedIsIn(GetPlayerPed(serverid), false) ~= nil then
            if GetVehiclePedIsIn(GetPlayerPed(serverid), false) ~= 0 then
                car = GetVehiclePedIsIn(GetPlayerPed(serverid), false)
                isCar = true
                success = true
            end
        end
        Citizen.Wait(50)
    until success

    local id = NetworkGetNetworkIdFromEntity(car)

    if car ~= nil and job ~= nil and isCar then
        data = {car, job, dead, vehicleType, isCar, false, stop, remove}
        players[id] = data
    end
end

-- this is the main update thread for pushing blip location updates to players
Citizen.CreateThread(function()
    while true do
        local mt_begin = GetGameTimer()
        local updateInterval = 0
        local updateIntervalLimit = 0
        for limit, interval in each(updateIntervals) do
            if(limit <= #players) then
                updateInterval = interval
                updateIntervalLimit = limit
            end
        end

        if(lastIntervalValue ~= updateIntervalLimit) then
            lastIntervalValue = updateIntervalLimit
            print(string.format("[^Blips^7] Updated blip update interval to ^2%dms (%d) ^7due to ^2%d ^7players being connected.", updateInterval, updateIntervalLimit, #players))
        end

        Citizen.CreateThread(function()
            local up_begin = GetGameTimer()
            -- iterate through the players table above and build an event object
            -- that includes the players' server ID and their in-game position
            local blips = {}
            for index, player in each(players) do
                if players[1] ~= 0 then
                    local playerID = player[1]
                    local playerPed = nil
                    local job = player[2]
                    local dead = player[3]
                    local vehType = player[4]
                    local isCar = player[5]
                    local car = false
                    local hide = player[6]
                    local stop = player[7]
                    local remove = player[8]

                    if player[4] == true then
                        playerPed = player[1]
                    else
                        playerPed = GetPlayerPed(player[1])
                    end

                    -- check if ped exists to refrain from iterating potentially invalid player entities
                    -- causes some players to not have blips if not double-checked
                    if(DoesEntityExist(playerPed)) then
                        if not remove then
                            if not stop then
                                local coords = GetEntityCoords(playerPed)
                                local heading = GetEntityHeading(playerPedA)
                                local name = ''


                                if isCar == true then
                                    name = job .. ' ' .. 'CarUnit' .. ' ' .. '#' .. player[1]
                                    if vehType == 15 or vehType == 16 then
                                        if job == 'plane' then
                                            name = job .. ' ' .. '#' .. player[1]
                                        else
                                            name = job .. 'plane' .. '#' .. player[1]
                                        end
                                    end
                                else
                                    name = job .. ' ' .. 'Unit' .. ' ' .. '#' .. playerID
                                end


                                if isCar then
                                    if tostring(GetVehicleEngineHealth(playerPed)) == '-nan' then
                                        players[index][3] = true
                                        dead = true
                                    else
                                        players[index][3] = false
                                    end
                                else
                                    if vehType ~= 22 then
                                        car = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(playerPed, false))
                                    end
                                end

                                local obj = {
                                    playerID, NetworkGetNetworkIdFromEntity(playerPed), job, name, { coords.x, coords.y, coords.z },
                                    dead, heading, vehType, isCar, car, hide, stop, remove

                                }

                                blips[playerPed] = obj
                            end
                        end
                    else
                        local id = nil
                        if isCar then
                            id = player[1]
                        else
                            id = index
                            TriggerClientEvent("player_blips:offblips", id, false)
                        end
                        TriggerClientEvent("player_blips:elimnate", -1, id, false)
                    end
                end
            end

            -- create another thread to quickly move-on to the next tick
            Citizen.CreateThread(function()
                for index, player in each(players) do
                    local hide = player[6]
                    local stop = player[7]
                    local remove = player[8]
                    if not remove then
                        if player[1] ~= 0 then
                            if (DoesEntityExist(player[1])) or (DoesEntityExist(GetPlayerPed(player[1]))) then
                                local final = {}
                                -- filter-out the players' blip from the blips array being sent
                                for index, blip in each(blips) do
                                    --if(blip[1] ~= player[1]) then
                                    table.insert(final, blip)
                                    --end
                                end

                                if (DoesEntityExist(GetPlayerPed(player[1]))) then
                                    TriggerClientEvent("player_blips:updateBlips", player[1], final)
                                end
                                Citizen.Wait(math.clamp(10, updateSpacing, 100))
                            end
                        end
                    else
                        players[index] = nil
                    end
                end
            end)

            lastBlipsUpdate = blips

            -- if threadTimeWarnings is enabled, then calculate the time it took to run this thread
            -- and if its above the threshold then send a warning to the server console
            if(threadTimeWarnings) then
                local up_loopTime = GetGameTimer() - up_begin
                if(up_loopTime > updateThreadTimeThreshold) then
                    print(string.format("[^Blips^7] Update thread loopTime: ^3%i ms ^7(your server is ^1lagging ^7or ^3updateThreadTimeThreshold ^7is too low)", up_loopTime))
                end
            end
        end)

        -- if threadTimeWarnings is enabled, then calculate the time it took to run this thread
        -- and if its above the threshold then send a warning to the server console
        if(threadTimeWarnings) then
            local mt_loopTime = GetGameTimer() - mt_begin
            if(mt_loopTime > mainThreadTimeThreshold) then
                print(string.format("[^Blips^7] Main thread loopTime: ^1%i ms ^7(your server is ^1lagging ^7or ^1mainThreadTimeThreshold ^7is too low)", mt_loopTime))
            end
        end

        Citizen.Wait(updateInterval)
    end
end)


--Admin blips
Citizen.CreateThread(function()
    while true do
        local mt_beginA = GetGameTimer()
        local updateAInterval = 0
        local updateAIntervalLimit = 0
        for limit, interval in each(updateIntervals) do
            if(limit <= #allplayers) then
                updateAInterval = interval
                updateAIntervalLimit = limit
            end
        end

        if(lastAIntervalValue ~= updateAIntervalLimit) then
            lastAIntervalValue = updateAIntervalLimit
            print(string.format("[^ABlips^7] Updated blip update interval to ^2%dms (%d) ^7due to ^2%d ^7players being connected.", updateAInterval, updateAIntervalLimit, #allplayers))
        end

        Citizen.CreateThread(function()
            local up_beginA = GetGameTimer()

            local blipsA = {}
            for indexE, playerE in each(allplayers) do
                if playerE ~= nil then
                    local playerIDA = indexE
                    local status = playerE[1]
                    local playerPedA = GetPlayerPed(indexE)
                    local heading = GetEntityHeading(playerPedA)
                    local adminPower = playerE[2]
                    local dead = playerE[3]
                    local car = playerE[4]
                    local job = playerE[5]

                    if (DoesEntityExist(playerPedA) and playerE[7] == nil) then
                        local coordsA = GetEntityCoords(playerPedA)
                        local nameA = GetPlayerName(playerIDA).. ' | '.. playerIDA

                        if status ~= 22 then
                            car = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(playerPedA, false))
                        end

                        local objA = {
                            playerIDA, NetworkGetNetworkIdFromEntity(playerPedA), nameA, { coordsA.x, coordsA.y, coordsA.z },
                            status, heading, adminPower, dead, car, job
                        }
                        blipsA[playerPedA] = objA
                    else
                        TriggerClientEvent("player_blips:elimnate", -1, indexE, true)
                        allplayers[indexE] = nil
                    end
                end
            end

            Citizen.CreateThread(function()
                for indexA, playerA in each(admins) do
                    if playerA[1] ~= 0 then
                        if DoesEntityExist(GetPlayerPed(playerA[1])) and not playerA[2] then
                            local finalA = {}
                            for indexAE, blipA in each(blipsA) do
                                --if(blipA[1] ~= playerA) then
                                table.insert(finalA, blipA)
                                --end
                            end
                            TriggerClientEvent("player_blips:updateABlips", playerA[1], finalA)
                            Citizen.Wait(math.clamp(10, updateSpacing, 100))
                        else
                            TriggerClientEvent("player_blips:offblips", indexA, true)
                            admins[indexA] = nil
                        end
                    end
                end
            end)

            lastABlipsUpdate = blipsA

            if(threadTimeWarnings) then
                local up_loopTimeA = GetGameTimer() - up_beginA
                if(up_loopTimeA > updateThreadTimeThreshold) then
                    print(string.format("[^ABlips^7] Update thread loopTime: ^3%i ms ^7(your server is ^1lagging ^7or ^3updateThreadTimeThreshold ^7is too low)", up_loopTimeA))
                end
            end
        end)

        if(threadTimeWarnings) then
            local mt_loopTimeA = GetGameTimer() - mt_beginA
            if(mt_loopTimeA > mainThreadTimeThreshold) then
                print(string.format("[^ABlips^7] Main thread loopTime: ^1%i ms ^7(your server is ^1lagging ^7or ^1mainThreadTimeThreshold ^7is too low)", mt_loopTimeA))
            end
        end
        Citizen.Wait(updateAInterval)
    end
end)