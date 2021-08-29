local Jobs = {}
local fileJson = nil
local dataJson = nil

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        fileJson = jsonLoadFile(GetResourcePath(GetCurrentResourceName()).."/jobs.json")
        dataJson = jsonLoadData(fileJson)
    end
end)

MySQL.ready(function()
    Wait(5)
    MySQL.Async.fetchAll(
            "SELECT * FROM jobs",
            {},
            function(result)
                if #result ~= 0 then
                    Jobs = result
                end
            end
    )
end)

function jsonLoadFile(file)
    local file = io.open(file, "r" )
    return file
end

function jsonLoadData(file)
    local content = ""
    local dataTable = {}
    if file then
        content = file:read( "*a" )
        dataTable = json.decode(content);
        return dataTable
    end
    --io.close( file )
    return file
end

function IsFile(fileName)
    local file = io.open(fileName, "r")
    if (file) then
        file:close()
        return true
    end
    return false
end


function jsonSaveData(t,file)
    local file = io.open(file, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        file:flush()
        io.close( file )
        return true
    else
        return false
    end
end

RegisterServerEvent('jobs:Authorized')
AddEventHandler('jobs:Authorized', function(jobs)
    local usableMarkers = {}

    for k, v in each(jobs) do
        usableMarkers[v.job] = dataJson[v.job]
    end

    TriggerClientEvent('jobs:Authorized', source, usableMarkers)
end)