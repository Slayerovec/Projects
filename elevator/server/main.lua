local TE, TCE,TSE, RNE, RSE, AEH, CCT, SNM, RNC = TriggerEvent, TriggerClientEvent,TriggerServerEvent, RegisterNetEvent, RegisterServerEvent, AddEventHandler, Citizen.CreateThread, SendNUIMessage, RegisterNUICallback
local config_elevators = Config.Elevators
local nearPlayers = {}
local calls = {}
local requests = {}
local ende = {}


RSE('elevator:call')
AEH('elevator:call', function(building, want)
    if calls[building] == nil then
        calls[building] = {}
    end
    table.insert(calls[building], want)
end)

RSE('elevator:ende')
AEH('elevator:ende', function(building)
    config_elevators[building].active = false
    config_elevators[building].current_floor = ende[building]
    ende[building] = nil
end)

RSE('elevator:request')
AEH('elevator:request', function(building, going)
    if requests[building] == nil then
        requests[building] = {}
    end
    table.insert(requests[building], { source, going })
end)

RSE('elevator:nearByPlayers')
AEH('elevator:nearByPlayers', function(building, floor)
    nearPlayers[source] = {
        building = building,
        floor = floor
    }
end)

CCT(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(nearPlayers) do
            TCE('elevator:ElevatorData', k, config_elevators[nearPlayers[k].building])
        end
    end
end)

CCT(function()
    while true do
        Citizen.Wait(2200)
        for k, v in pairs(calls) do
            if #calls[k] ~= 0 then
                if not config_elevators[k].active then
                    for i = 1, #v do
                        if config_elevators[k].current_floor ~= v[i] then
                            config_elevators[k].active = true
                            Citizen.Wait(1000)
                            config_elevators[k].current_floor = v[i]
                            config_elevators[k].active = false
                            Citizen.Wait(1000)
                            table.remove(calls, i)
                        else
                            table.remove(calls, i)
                        end
                    end
                end
            end
        end
    end
end)

CCT(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(requests) do
            local test = {}
            if #requests[k] ~= 0 then
                if not config_elevators[k].active then
                    config_elevators[k].active = true
                    for i = 1, #v do
                        test[v[i][2]] = {}
                    end
                    for i =1, #v do
                        table.insert(test[v[i][2]], v[i][1])
                    end
                    Citizen.Wait(10000)
                    for l, m in pairs(test) do
                        for i = 1, #m do
                            TCE('elevator:going', m[i], l)
                            Citizen.Wait(100)
                        end
                        print(l)
                        ende[k] = l
                    end
                    requests[k] = {}
                end
            end
        end
    end
end)