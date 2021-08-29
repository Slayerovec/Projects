local isSpawned, isDead, jobs, markerName, markerLabel, isShowingHint = false, false, false, nil, nil, false
local closeDistanceBreak, closeJob, closeGrade, closeJobMarker = false, false, nil, nil
local isDuty, dutyJob, dutyGrade = false, nil, nil
local pref, restartedResource = false, false
local pCoords = nil

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        restartedResource = true
        isSpawned = true
        jobs = exports.data:getCharVar("jobs")
        TriggerServerEvent('jobs:Authorized', jobs)
        for _, v in each(jobs) do
            if v['duty'] then
                dutyJob = v.job
                isDuty = v.duty
                dutyGrade = v.job_grade
                break
            end
        end
    end
end)

RegisterNetEvent("s:statusUpdated")
AddEventHandler("s:statusUpdated", function(status)
    isDead = (status == "dead")
    if status == "spawned" then
        isSpawned = true
        jobs = exports.data:getCharVar("jobs")
        TriggerServerEvent('jobs:Authorized', jobs)
        for _, v in each(jobs) do
            if v['duty'] then
                dutyJob = v.job
                isDuty = v.duty
                dutyGrade = v.job_grade
                break
            end
        end
    end
end)

RegisterNetEvent("s:jobUpdated")
AddEventHandler("s:jobUpdated", function(job, grade, duty)
    jobs = job
    TriggerServerEvent('jobs:Authorized', job)
    for _, v in each(jobs) do
        if v['duty'] then
            dutyJob = v.job
            isDuty = v.duty
            dutyGrade = v.job_grade
            break
        end
    end
end)

RegisterNetEvent("jobs:Authorized")
AddEventHandler("jobs:Authorized", function(markers)
    pref = markers
    if restartedResource then
        for _, jobMarkers in each(pref) do
            for marker = 1, #jobMarkers do
                exports["key_hints"]:hideHint({["name"] = string.format("job_%s", marker)})
            end
        end
        restartedResource = false
    end
end)

function GetJobSpec(name)
    if Config.JobSpecs[name] then
        return Config.JobSpecs[name]
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        if isSpawned and not isDead and jobs[1] ~= nil then
            pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        end
        Citizen.Wait(2000)
    end
end)


Citizen.CreateThread(function()
    while true do
        if isSpawned and jobs[1] ~= nil and pCoords ~= nil and not isDead then
            if pref then
                for job, jobMarkers in each(pref) do
                    for marker = 1, #jobMarkers do
                        local coords = jobMarkers[marker]["coords"]
                        if coords["x"] ~= 0.00 then
                            local distance = GetDistanceBetweenCoords(pCoords, coords["x"], coords["y"], coords["z"], true)

                            if distance < 50 then
                                if closeJob ~= job and closeJobMarker ~= marker then
                                    closeJobMarker = marker
                                    closeJob = job
                                    for _, v in each(jobs) do
                                        if v['job'] == closeJob then
                                            closeGrade = v.job_grade
                                            break
                                        end
                                    end
                                    closeDistanceBreak = false
                                end
                            else
                                if closeJob == job and closeJobMarker == marker then
                                    closeDistanceBreak = true
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local distance = 1
        if not closeDistanceBreak and pref then
            if closeJob ~= nil and closeJobMarker ~= nil then
                local prefix = pref[closeJob][closeJobMarker]
                local enoughGrade = false
                distance = GetDistanceBetweenCoords(pCoords, prefix["coords"]["x"], prefix["coords"]["y"], prefix["coords"]["z"], true)
                if (dutyJob == nil) or (not prefix['offduty'] and (closeJob == dutyJob))then
                    if distance < prefix["distance"] then
                        if distance < prefix["range"] then
                            if not isShowingHint then
                                for _, grade in each(prefix["grade"]) do
                                    if grade == closeGrade then
                                        enoughGrade = true
                                        break
                                    end
                                end
                                if enoughGrade then
                                    markerName = prefix["name"]
                                    markerLabel = prefix["label"]
                                    isShowingHint = true
                                    exports["key_hints"]:displayHint({["name"] = string.format("job_%s", markerName), ["key"] = "~INPUT_DAF1F3B5~", ["text"] = string.format('Otevřít %s', markerLabel), ["coords"] = vector3(prefix["coords"]["x"], prefix["coords"]["y"], prefix["coords"]["z"])})
                                end
                            end
                        else
                            if markerName ~= nil and isShowingHint then
                                exports["key_hints"]:hideHint({["name"] = string.format("job_%s", markerName)})
                                markerName = nil
                                markerLabel = nil
                                isShowingHint = false
                            end
                        end
                    end
                end
            end
        else
            distance = 50
        end
        Citizen.Wait(50 * distance)
    end
end)

RegisterCommand(
        "openJobMarker",
        function()
            if markerName ~= nil and isShowingHint then
                if markerName == "duty" then
                    isDuty = not isDuty
                    TriggerServerEvent("base_jobs:updateDuty", isDuty)
                    exports.notify:display({type = "info", title = "Služba", text = isDuty and "Přišel jste do služby" or "Odešel jste ze služby", icon = "fas fa-briefcase", length = 3000})
                    exports.base_jobs:forceBonus()
                elseif markerName == "bossmenu" then
                    exports.boss:openBossMenu(closeJob)
                elseif markerName == "cloakroom" then
                    exports.clothes_shop:openOwnedClothesMenu()
                elseif markerName == "fridge" then
                    exports.inventory:openStorage("fridge", closeJob, {maxWeight = 250.0, maxSpace = 50, label = markerLabel.. ' ' ..string.upper(closeJob)})
                elseif markerName == "safe" then
                    exports.inventory:openStorage("safe", closeJob, {maxWeight = 250.0, maxSpace = 50, label = markerLabel.. ' ' ..string.upper(closeJob)})
                elseif markerName == "vault" then
                    exports.inventory:openStorage("vault", closeJob, {maxWeight = 250.0, maxSpace = 50, label = markerLabel.. ' ' ..string.upper(closeJob)})
                elseif markerName == "secretvault" then
                    exports.inventory:openStorage("secretvault", closeJob, {maxWeight = 250.0, maxSpace = 50, label = markerLabel.. ' ' ..string.upper(closeJob)})
                else
                    exports.notify:display({type = "info", title = "Služba", text = "Něco nefunguje, hmm..", icon = "fas fa-briefcase", length = 3000})
                end
            end
        end,
        false
)

RegisterCommand(
        "openJobMenu",
        function()
            if isDuty and dutyJob ~= nil then
                if Config.JobSpecs[dutyJob] == 'bar' then
                    barMenu()
                elseif Config.JobSpecs[dutyJob] == 'mechanic' then
                    mecMenu()
                else
                    jobMenu()
                end
            end
        end,
        false
)

createNewKeyMapping({command = "openJobMarker", text = "Otevřít Job Marker Menu", key = "E"})
createNewKeyMapping({command = "openJobMenu", text = "Otevřít Job Menu", key = "F6"})
