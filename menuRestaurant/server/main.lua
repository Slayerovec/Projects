local TE, TCE,TSE, RNE, RSE, AEH, CCT, SNM, RNC = TriggerEvent, TriggerClientEvent,TriggerServerEvent, RegisterNetEvent, RegisterServerEvent, AddEventHandler, Citizen.CreateThread, SendNUIMessage, RegisterNUICallback

RegisterCommand('jdl', function(source, args)
    local _source = source
    local restaurant = exports.data:getCharVar("job")
    local ID = tonumber(args[1])
    if ID then
        TCE("menuRestaurant:jidelak", args[1], restaurant)
    else
        TCE("menuRestaurant:menu", _source)
    end
end, false)