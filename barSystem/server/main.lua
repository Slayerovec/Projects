local TE, TCE,TSE, RNE, RSE, AEH, CCT, SNM, RNC = TriggerEvent, TriggerClientEvent,TriggerServerEvent, RegisterNetEvent, RegisterServerEvent, AddEventHandler, Citizen.CreateThread, SendNUIMessage, RegisterNUICallback
local consumables = {}
local loaded = false

MySQL.ready(function()
    Wait(500)
    MySQL.Async.fetchAll("SELECT * FROM consumables", {}, function(items)
        for _, v in each(Config.Categories) do
            consumables[v] = {}
        end
        for _, v in each(items) do
            consumables[v.type][v.label] = {
                id = v.id,
                capacity = v.capacity,
                volume = v.volume,
                img = v.img,
                description= v.description,
                unique = v.unique2,
                cost = json.decode(v.cost)[1],
                production = json.decode(v.production)[1] or false,
                restaurants = json.decode(v.restaurants)[1]
            }
        end
    end)
    SetTimeout(Config.Wait, saveAll)
end)

function createMenu(restaurant)
    local menu = {}
    for type, item in each(consumables) do
        menu[type] = {}
        for name, data in each(item) do
            if data.restaurants and data.cost then
                if data.restaurants and data.cost then
                    menu[type][name] = {
                        id = data.id,
                        capacity = data.capacity,
                        volume = data.volume,
                        img = data.img,
                        description= data.description,
                        unique = data.unique,
                        cost = data.cost[restaurant],
                        production = data.production,
                        restaurants = data.restaurants[restaurant]
                    }
                end
            end
        end
    end
    return menu
end

function saveAll()
    for _, consumable in each(consumables) do
        for _, drink in each(consumables) do
            MySQL.Async.fetchAll("UPDATE consumables SET restaurants=@restaurants, cost=@cost WHERE id=@id", {
                ["@restaurants"] = json.encode(drink.restaurant),
                ["@cost"] = json.encode(drink.cost),
                ["@id"] = item
            })
        end
    end
end

function getConsumable(drinkId)
    if type(drinkId) == "number" then
        for type, item in each(consumables) do
            for name, data in each(item) do
                if data.id == drinkId then
                    return consumables[type][name]
                end
            end
        end
    elseif type(drinkId) == "string" then
        for type, item in each(consumables) do
            for name, data in each(item) do
                if data.img == drinkId then
                    return consumables[type][name]
                end
            end
        end
    end
    return nil
end

RSE(GetHandlerName('getMeConsumables'))
AEH(GetHandlerName('getMeConsumables'), function()
    TCE(GetHandlerName('getMeConsumables'), source, consumables)
end)

RSE(GetHandlerName('openMenu'))
AEH(GetHandlerName('openMenu'), function(itemName, restaurant)
    local _source = source
    local menu = createMenu(restaurant)
    if menu then
        TCE(GetHandlerName('openMenu'), _source, restaurant, itemName, menu)
    end
end)

RSE(GetHandlerName('makeMenu'))
AEH(GetHandlerName('makeMenu'), function(item, data)
    local _source = source
    if item.data.id == nil then
        exports.inventory:updateItemDataBySlot(_source, item.slot, itemData)
    end
end)

RSE(GetHandlerName('UpdateItem'))
AEH(GetHandlerName('UpdateItem'), function(action, data, restaurant)
    local drinkId = tonumber(data.drinkId)
    if action == "addToMenu" then
        local price = tonumber(data.price)
        for type, item in each(consumables) do
            for name, data in each(item) do
                if data.id == drinkId then
                    if consumables[type][name].restaurants[restaurant] then
                        consumables[type][name].restaurants[restaurant] = true
                    end
                    if consumables[type][name].cost[restaurant] then
                        consumables[type][name].cost[restaurant] = price
                    end
                end
            end
        end
    elseif action == "removeFromMenu" then
        for type, item in each(consumables) do
            for name, data in each(item) do
                if data.id == tonumber(drinkId) then
                    if consumables[type][name].restaurants[restaurant] then
                        consumables[type][name].restaurants[restaurant] = false
                        break
                    end
                end
            end
        end
    else
        local price = data.price
        for type, item in each(consumables) do
            for name, data in each(item) do
                if data.id == drinkId then
                    if consumables[type][name].cost[restaurant] then
                        consumables[type][name].cost[restaurant] = price
                        break
                    end
                end
            end
        end
    end
    local _source = source
    local menu = createMenu()
    if menu then
        TCE(GetHandlerName('refreshMenu'), _source, restaurant, "alcohol_menu", menu)
    end
end)

RSE(GetHandlerName("CreateDrink"))
AEH(GetHandlerName("CreateDrink"), function(data)
    local Player = exports.data:getUser(source).nickname
    --webhookImage = 'https://i.imgur.com/6kaSkjJ.gifv'
    local webhookImage = 'https://www.realbookies.com/wp-content/uploads/2019/03/reporting-analytics_60.png'
    if exports.control:isDev() then
        webhookUrl = 'https://discord.com/api/webhooks/873095311432769616/PXs7_sdotD0Pyy6NbXranXWtDwJsoNTUN_wWzUmB6v2kEdj7vICZUE2QK72xgRFKeQEB'
    else
        webhookUrl = "https://discord.com/api/webhooks/873106454314377237/d9XG-HdTwiAiFZuyI5-Jq2FLEktChS5bVsyLqTUD13QJXE4LMd7TkNl8aqJxkpYmtaq8"
    end

    content = '```Chce vytvořit drink: \n name: ' .. data.name .. '\n type: ' .. data.type .. '\n description:' .. data.description .. '\n volume: ' .. data.volume .. '\n capacity: ' .. data.capacity .. '\n unique:' .. data.unique .. '```'

    PerformHttpRequest(webhookUrl, function(e, t, h) end, 'POST', json.encode({
        username = Player,
        content = content

    }), { ['Content-Type'] = 'application/json' })
    TCE("notify:display", _source, {type = "success", title = "Odesláno", text = "Tvůj návrh byl zaslán! 👿", icon = "fas fa-times", length = 5000})
end)

RegisterCommand('givebaritem', function(source, args)
    if exports.data:getUserVar(source, "admin") >= 2 then
        data = {
            item = args[2],
            id = args[3]
        }
        exports.inventory:addPlayerItem(tonumber(args[1]), data.item, 1, data)
    end
end, false)