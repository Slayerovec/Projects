--Investigate
local investigate = {
    shell = {},
    blood = {}
}
RegisterServerEvent('weapons_scripts:server:shot')
AddEventHandler('weapons_scripts:server:shot', function(coords, weapon, clothes)
    local src = source
    local Player = exports.data:getCharVar(src, 'id')
    local shell = Config.Shell[weapon.ammoType]
    local newObj = CreateObject(GetHashKey(shell), coords.x, coords.y, coords.z + 0.2, true, true, false)
    SetEntityRotation(newObj, -90.0, 0.0, 0.0, 2, false)
    FreezeEntityPosition(newObj, true)
    table.insert(investigate.shell,{ pos = coords, type = shell, obj = newObj,  charid = Player, data = weapon })
    gsr_test(coords, weapon, Player, clothes)
end)

RegisterServerEvent('weapons_scripts:server:getshot')
AddEventHandler('weapons_scripts:server:getshot', function(coords, weapon)
    local src = source
    local Player = exports.data:getCharVar(src, 'id')
    local newObj = CreateObject(GetHashKey(Config.BloodObject), coords.x, coords.y, coords.z, true, true, false)
    SetEntityRotation(newObj, -90.0, 0.0, 0.0, 2, false)
    FreezeEntityPosition(newObj, true)
    table.insert(investigate.blood,{ pos = coords, type = Config.BloodObject, obj = newObj, charid = Player, data = weapon })
end)

--Gsr
local GSR = {}
function getKey(charid)
    local key = false
    for k, v in each(GSR) do
        if v.charid == charid then
            key = k
            break
        end
    end
    return key
end
function gsr_test(coords, weapon, Player, clothes)
    local key = getKey(Player)
    if key then
        for i=1, #GSR[key].clothes do
            GSR[key].clothes[i].powder = GSR[key].clothes[i].powder + 1
        end
    else
        for i=1, #clothes do
            clothes[i].powder = clothes.powder + 1
        end
        local data = {
            coords = coords,
            weapon = weapon,
            charid = Player,
            clothes = clothes
        }
        table.insert(GSR, data)
    end
    --Utils.DumpTable(GSR)
    --TriggerClientEvent('weapons_scripts:client:GSR', -1)
end
RegisterServerEvent('weapons_scripts:server:GSR')
AddEventHandler('weapons_scripts:server:GSR', function(data)
    local src = source
    local Player = exports.data:getCharVar(data.player, 'id')
    local found = false
    if Player then
        local key = getKey(Player)
        if key then
            if GSR[key].clothes[data.selected].number == data.clothes[data.selected].number then
                if GSR[key].clothes[data.selected].powder ~= 0 then
                    found = GSR[key].clothes[data.selected].powder
                end
            else
                GSR[key].clothes[data.selected].number = data.clothes[data.selected].number
                if data.clothes[data.selected].powder ~= 0 then
                    found = data.clothes[data.selected].powder
                end
            end
            if found then
                TriggerClientEvent('notify:display', src, {type = "success", title = "GSR Test Kit", text = string.format("Byly nalezeny stopy střelného prachu na %s", data.clothes[data.selected].name), icon = "fas fa-times", length = 5000})
            else
                TriggerClientEvent('notify:display', src, {type = "success", title = "GSR Test Kit", text = string.format("Nebyly nalezeny žádne stopy střelného prachu na %s", data.clothes[data.selected].name), icon = "fas fa-times", length = 5000})
            end
        else
            TriggerClientEvent('notify:display', src, {type = "success", title = "GSR Test Kit", text = string.format("Nebyly nalezeny žádne stopy střelného prachu na %s", data.clothes[data.selected].name), icon = "fas fa-times", length = 5000})
        end
    end
end)

RegisterServerEvent('weapons_scripts:server:clean')
AddEventHandler('weapons_scripts:server:clean', function(data)
    local src = source
    local Player = exports.data:getCharVar(src, 'id')
    local key = getKey(Player)
    if data.type ~= "water" then
        if key then
            GSR[key].clothes[data.selected].powder = 0
            TriggerClientEvent('notify:display', src, {type = "success", title = "Umytí", text = string.format("Umyl sis %s", GSR[key].clothes[data.selected].name), icon = "fas fa-shower", length = 5000})
        else
            TriggerClientEvent('notify:display', src, {type = "success", title = "Umytí", text = string.format("Nepotřebuješ se umýt smradochu."), icon = "fas fa-shower", length = 5000})
        end
    else
        if key then
            GSR[key].clothes = data.clothes
            TriggerClientEvent('notify:display', src, {type = "success", title = "Umytí", text = string.format("Umyl ses celej"), icon = "fas fa-shower", length = 5000})
        end
    end
end)

RegisterServerEvent('weapons_scripts:server:giveGSR')
AddEventHandler('weapons_scripts:server:giveGSR', function(itemName, amount, data, slot)
    local src = source
    Utils.DumpTable(data)
    exports.inventory:addPlayerItem(src, itemName, amount, data, slot)
end)

--Animation
RegisterServerEvent('weapons_scripts:server:animation')
AddEventHandler('weapons_scripts:server:animation', function(ped, anim)
    TriggerClientEvent('weapons_scripts:client:animation', -1, ped, anim)
end)