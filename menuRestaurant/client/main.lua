local TE, TCE, TSE, RNE, RSE, AEH, CCT, SNM, RNC = TriggerEvent, TriggerClientEvent, TriggerServerEvent, RegisterNetEvent, RegisterServerEvent, AddEventHandler, Citizen.CreateThread, SendNUIMessage, RegisterNUICallback
local pref = Config.Menus
local ESX = nil
local JobName, waitress, haveMenu, Restaurant = nil, false, false, nil


RNE("s:statusUpdated")
AEH("s:statusUpdated",
        function(status)
            if status == "choosing" then
            elseif status == "spawned" or status == "dead" then
                if JobName == nil then
                    JobName = exports.data:getCharVar("job")
                    if pref[JobName] then
                        waitress = true
                        haveMenu = true
                        Restaurant = JobName
                    end
                end
            end
        end
)

RNE("s:jobUpdated")
AEH("s:jobUpdated",
        function(job, grade, duty)
            JobName = job
            if pref[JobName] then
                waitress = true
                haveMenu = true
                Restaurant = JobName
            end
        end
)

RNE('menuRestaurant:jidelak')
AEH('menuRestaurant:jidelak', function(restaurant)
    if not haveMenu and not waitress then
        haveMenu = true
        Restaurant = restaurant
    elseif haveMenu and not waitress then
        haveMenu = false
        Restaurant = nil
    end
end)

RNE('menuRestaurant:menu')
AEH('menuRestaurant:menu', function()
    if haveMenu then
        SetNuiFocus(true, true)
        SNM({ action = "open", restaurant = pref[Restaurant] })
    end
end)

RNC('close', function()
    SetNuiFocus(false, false)
    SNM({ action = "close" })
end)

CCT(function()
end)

RegisterCommand('tst2', function(source, args)
    print( haveMenu..'    '..waitress..'      '..restaurant)
end, false)

RegisterCommand('close', function(source, args)
    SetNuiFocus(false, false)
end, false)