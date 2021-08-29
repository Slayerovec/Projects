local telegrams = {}
local index = 1
local menu = false
local firstname = nil
local lastname = nil

------------------------------------
--- ADD YOUR OWN LOCATIONS BELOW ---
------------------------------------

local locations = {
    { x=-178.90, y=626.71, z=114.09 }, -- Valentine train station
    { x=1225.57, y=-1293.87, z=76.91 }, -- Rhodes train station
    { x=2731.55, y=-1402.37, z=46.18 }, -- Saint Denis train station
}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Citizen.Wait(500)
    TriggerServerEvent('Telegram:GetName')
end)

RegisterNetEvent("Telegram:Name")
AddEventHandler("Telegram:Name", function(data)
    firstname = data["firstname"]
    lastname = data["lastname"]
end)

RegisterNetEvent("Telegram:ReturnMessages")
AddEventHandler("Telegram:ReturnMessages", function(data, current)
    index = 1
    telegrams = data
    values = nil

    if #telegrams == 0 then
        values = 'test'
    else
        values = 'done'
    end

    if next(telegrams) == nil then
        SendNUIMessage({ action = "telegrams" })
    else
        SendNUIMessage({ action = "telegrams", data = telegrams, current = current, values = values })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for key, value in pairs(locations) do
           if IsPlayerNearCoords(value.x, value.y, value.z) then
                if not menu then
                    SetNuiFocus(false, false)
                    exports.kkrp_core:DrawA("Stiskni [~e~G~q~] pro zobrazneí telegramu.", 0.5, 0.88)
                    if IsControlJustReleased(0, 0x760A9C6F) then
                        menu = true
                        OpenTelegram()
                    end
                end
            end
        end
    end
end)

function IsPlayerNearCoords(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 1 then
        return true
    end
end

function DrawText(text,x,y)
    SetTextScale(0.35,0.35)
    SetTextColor(255,255,255,255)--r,g,b,a
    SetTextCentre(true)--true,false
    SetTextDropshadow(1,0,0,0,200)--distance,r,g,b,a
    SetTextFontForCurrentCommand(0)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

function CloseTelegram()
    index = 1
    menu = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

function OpenTelegram()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open" })
end

RegisterNUICallback('back', function()
    if index ~= 1 then
        index = index - 1
    end

    if index <= #telegrams  then
        SendNUIMessage({ action = 'open_telegram', data = { sender = telegrams[index].sender, reciever = telegrams[index].reciever, message = telegrams[index].message, id = telegrams[index].id }})
    end
end)

RegisterNUICallback('reopen', function()
    OpenTelegram()
end)

RegisterNUICallback('next', function()
    if index ~= #telegrams then
        index = index + 1
    end

    if index <= #telegrams then
        SendNUIMessage({ action = 'open_telegram', data = { sender = telegrams[index].sender, reciever = telegrams[index].reciever, message = telegrams[index].message, id = telegrams[index].id }})
    end
end)

RegisterNUICallback('close', function()
    CloseTelegram()
end)

RegisterNUICallback('open_telegram', function(data)
    index = data["telegramId"] + 1
    SendNUIMessage({ action = 'open_telegram', data = { sender = telegrams[index].sender, reciever = telegrams[index].reciever, message = telegrams[index].message, id = telegrams[index].id }})
    isRead = data["isRead"]
    dbId = data['telegramDbId']
    if isRead == false then
        TriggerServerEvent("Telegram:ReadMessages", dbId)
    end
end)

RegisterNUICallback('telegrams', function()
    TriggerServerEvent("Telegram:GetMessages")
end)

RegisterNUICallback('sended', function()
    TriggerServerEvent("Telegram:GetSendedMessages")
end)

RegisterNUICallback('new', function()
    if firstname ~= nil then
        name = firstname .. " " .. lastname
        SendNUIMessage({ action = 'new_telegram', name = name})
    else
        print('Just wait!')
    end
end)

RegisterNUICallback('new_post', function(data)
    names = splitter(data['reciever'], ' ')
    message = data['message']
    price = data['price']
    firstnameR = names[1]
    lastnameR = names[2]
    if firstname ~= nil and lastname ~= nil and message ~= nil then
        TriggerServerEvent('Telegram:SendMessage', firstnameR, lastnameR, message, price)
    end
end)

RegisterNUICallback('delete', function()
    TriggerServerEvent("Telegram:DeleteMessage", telegrams[index].id)
end)

function splitter(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end