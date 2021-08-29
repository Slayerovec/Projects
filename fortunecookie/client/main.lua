function ToggleUI(state)
    if not state and isNuiVisible then
        SendNUIMessage({open = false})
        isNuiVisible = false
    end

    if state and not isNuiVisible then
        SendNUIMessage({open = true})
        isNuiVisible = true
    end
end

function zrusit()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 73) then
            isNuiVisible = true
            ToggleUI(false)
        end
    end        
end

RegisterNUICallback('disableHud', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ open = false })
end)

RegisterNetEvent('fortunecookie:open')
AddEventHandler('fortunecookie:open', function()
    isNuiVisible = false
    ToggleUI(true)
    number = math.random(1, #Config.FortuneCookie)
    data = Config.FortuneCookie[number]
    SendNUIMessage({
        number = number,
        data = data
    })
    zrusit()
end)