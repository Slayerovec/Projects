Active = false
Active_Weapon = false
local isDead = false
local current_ammo = 0
local breaked = false
local strength = 0
local button = 24
local vehicle = false
local animNumber = 1
local Anim = "Default"
-- Fire mode variables
FireMode = {}
-- Weapons the client currently has
FireMode.Weapons = {}
-- Last weapon in use
FireMode.LastWeapon = false
FireMode.LastWeaponSlot = nil
-- Last weapon type in use
FireMode.LastWeaponActive = false
-- Is shooting currently disabled?
FireMode.ShootingDisable = false
-- Is the client reloading?
FireMode.Reloading = false

RegisterNetEvent("s:statusUpdated")
AddEventHandler(
        "s:statusUpdated",
        function(status)
            isDead = (status == "dead")
            if status == "spawned" then
                strength = exports.data:getCharVar("skills").strength
            end
        end
)

RegisterNetEvent("weapons_scripts:client:animation")
AddEventHandler("weapons_scripts:client:animation", function(ped, anim)
    if Anim ~= anim then
        if anim == nil then
            animNumber = animNumber + 1
            if animNumber > #Config.Animations then animNumber = 1 end
            Anim = Config.Animations[animNumber]
        else
            for i= 1, #Config.Animations do
                if Config.Animations[i] == anim then
                    animNumber = i
                    Anim = Config.Animations[i]
                end
            end
        end
        if Anim then
            SetWeaponAnimationOverride(ped, GetHashKey(Anim))
            exports.notify:display({type = "success", title = "Změna Animace", text = string.format("%s", Anim), icon = "fas fa-times", length = 500})
        end
    end
end)

function fire_ratio()
    local Mode = 'error'
    if Active == "full" then
        if FireMode.Weapons[Active_Weapon].fireMode <= 2 then
            if FireMode.Weapons[Active_Weapon].fireMode == 0 then
                Mode = "single"
                FireMode.ShootingDisable = false
            elseif FireMode.Weapons[Active_Weapon].fireMode == 1 then
                Mode = "burst"
                FireMode.ShootingDisable = false
            elseif FireMode.Weapons[Active_Weapon].fireMode == 2 then
                Mode = "full_auto"
                FireMode.ShootingDisable = false
            end
            PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
            FireMode.Weapons[Active_Weapon].fireMode = FireMode.Weapons[Active_Weapon].fireMode + 1
            FireMode.ShootingDisable = false
        elseif FireMode.Weapons[Active_Weapon].fireMode >= 3 then
            Mode = "safety"
            PlaySoundFrontend(-1, "Reset_Prop_Position", "DLC_Dmod_Prop_Editor_Sounds", 0)
            FireMode.Weapons[Active_Weapon].fireMode = 0
            FireMode.ShootingDisable = true
        end
    else
        if FireMode.Weapons[Active_Weapon].fireMode == 0 then
            Mode = "single"
            PlaySoundFrontend(-1, "Reset_Prop_Position", "DLC_Dmod_Prop_Editor_Sounds", 0)
            FireMode.Weapons[Active_Weapon].fireMode = FireMode.Weapons[Active_Weapon].fireMode + 1
            FireMode.ShootingDisable = false
        elseif FireMode.Weapons[Active_Weapon].fireMode == nil or FireMode.Weapons[Active_Weapon].fireMode >= 1 then
            Mode = "safety"
            PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
            FireMode.Weapons[Active_Weapon].fireMode = 0
            FireMode.ShootingDisable = true
        end
    end
    exports.notify:display({type = "success", title = "Změna FireMode", text = string.format("%s", Mode), icon = "fas fa-times", length = 500})
    TriggerServerEvent("inventory:setWeaponFireMode", Active_Weapon, FireMode.Weapons[Active_Weapon].fireMode, current_ammo)
end

function reload()
    local playerPed = PlayerPedId()
    local maxAmmo = GetMaxAmmoInClip(playerPed, Active_Weapon, 1)
    local looking_for_magazine = false
    local found = {}

    if FireMode.Weapons[Active_Weapon].hasAmmo then
        if FireMode.Weapons[Active_Weapon].hasClip then
            looking_for_magazine = true
        end

        for _, v in each(exports.inventory:getUsableItems()) do
            if not looking_for_magazine and v.data.isAmmo then
                --print(FireMode.Weapons[Active_Weapon].ammoType == v.ammoType)
                if FireMode.Weapons[Active_Weapon].ammoType == v.ammoType then
                    exports.inventory:reload_weapon(playerPed, Active_Weapon, maxAmmo, FireMode.Weapons[Active_Weapon].ammo, FireMode.Weapons[Active_Weapon], v.name, v.slot, v.data)
                    break
                end
            elseif looking_for_magazine and v.data.isMagazine then
                --print(split(weapon.name, '_')[2], split(v.name, '_')[2], split(weapon.name, '_')[2] == split(v.name, '_')[2])
                if split(FireMode.Weapons[Active_Weapon].name, '_')[2] == split(v.name, '_')[2] then
                    if v.data.currentAmmo ~= 0 then
                        table.insert(found, { v.data.currentAmmo, v.name, v.slot, v.data })
                    end
                end
            end
        end

        table.sort(found, function(a, b) return a[1] > b[1] end)

        if found[1] ~= nil then
            --print(found[1][2], found[1][3], found[1][4])
            exports.inventory:reload_weapon(playerPed, Active_Weapon, maxAmmo, FireMode.Weapons[Active_Weapon].ammo, FireMode.Weapons[Active_Weapon], found[1][2], found[1][3], found[1][4])
        end
    end

    FireMode.ShootingDisable = false
    FireMode.Reloading = false
end

function flash_light()
    if IsFlashLightOn(PlayerPedId()) then
        SetFlashLightKeepOnWhileMoving(1)
    else
        SetFlashLightKeepOnWhileMoving(0)
    end
end

function shooting()
    local GamePlayCam = GetFollowPedCamViewMode()
    local MovementSpeed = math.ceil(GetEntitySpeed(PlayerPedId()))
    if MovementSpeed > 69 then
        MovementSpeed = 69
    end
    if Active_Weapon ~= 126349499 then
        local group = GetWeapontypeGroup(Active_Weapon)
        --print('group' .. group)
        local p = GetGameplayCamRelativePitch()
        local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(PlayerPedId()))
        local rightleft = math.random(0, 4)
        local h = GetGameplayCamRelativeHeading()
        local hf = math.random(10,40+MovementSpeed)/100
        local recoil = math.random(100,140+MovementSpeed)/100

        if cameraDistance < 5.3 then
            cameraDistance = 1.5
        else
            if cameraDistance < 8.0 then
                cameraDistance = 4.0
            else
                cameraDistance = 7.0
            end
        end

        if vehicle then
            recoil = recoil + (recoil * cameraDistance)
        else
            recoil = recoil * 0.1
        end

        if GamePlayCam == 4 then
            recoil = recoil * 1.0
        end


        if group == 970310034 then -- rifle
            recoil = recoil * (7.0 - strength / 20)
            hf = hf * (3.0 - strength / 20)
        elseif group == 860033945 then -- shotgun
            recoil = recoil * (15.0 - strength / 20)
            hf = hf * (15.0 - strength / 20)
        elseif group == 416676503 then -- handgun
            recoil = recoil * (3.0 - strength / 20)
            hf = hf * (2.0 - strength / 20)
        elseif group == -957766203 then -- machine
            recoil = recoil * ( 3.0 - strength / 20)
            hf = hf * ( 2.0 - strength / 20)
        end

        if vehicle then
            hf = hf * 10.5
        end

        recoil = recoil + ( rightleft / 5)
        hf = hf + ( rightleft / 5)

        --print('hf'.. hf)
        if rightleft == 1 or rightleft == 2 then
            SetGameplayCamRelativeHeading(h+hf)
        elseif rightleft == 3 or rightleft == 4 then
            SetGameplayCamRelativeHeading(h-hf)
        end

        local set = p+recoil
        --print('recoil' .. recoil)
        SetGameplayCamRelativePitch(set,0.8)
    end
end

-- Update skill set
Citizen.CreateThread(function()
    while true do
        local newStrength = exports.data:getCharVar("skills").strength
        if newStrength ~= 0 then
            strength = newStrength
        end
        Citizen.Wait(5000)
    end
end)

-- Resource master loop
Citizen.CreateThread(function()
    while true do
        if IsPedArmed(PlayerPedId(), 4) then
            Active_Weapon = GetSelectedPedWeapon(PlayerPedId())%0x100000000
            if Active_Weapon ~= FireMode.LastWeapon then
                if Config.Weapons[Active_Weapon] ~= nil then
                    for k, v in each(exports.inventory:getActiveWeapons()) do
                        if Active_Weapon == GetHashKey(k) then
                            Active = Config.Weapons[Active_Weapon]
                            FireMode.Weapons[Active_Weapon] = v.data
                            FireMode.Weapons[Active_Weapon].name = k
                            FireMode.Weapons[Active_Weapon].hasClip = exports.inventory:getWeaponFromHash(GetSelectedPedWeapon(PlayerPedId())).hasClip
                            FireMode.LastWeapon = Active_Weapon
                            FireMode.LastWeaponActive = Active
                            break
                        end
                    end
                else
                    FireMode.LastWeaponActive = false
                end
            else
                Active = FireMode.LastWeaponActive
            end
            if Active_Weapon and not Active then
                FireMode.ShootingDisable = true
            end
        else
            if Active then
                Active = false
                Active_Weapon = false
                FireMode.LastWeapon = false
                FireMode.LastWeaponActive = false
                TriggerServerEvent("weapons_scripts:server:animation", PlayerPedId(), 'Default')
            end
            FireMode.ShootingDisable = false
        end
        Citizen.Wait(500)
    end
end)

-- Resource master loop
Citizen.CreateThread(function()
    while true do
        if Active and Active_Weapon then
            if IsControlJustPressed(1, 54) then
                flash_light()
            end

            if vehicle then
                button = 69
            else
                button = 24
            end

            -- If fire mode is set to safety
            if FireMode.Weapons[Active_Weapon].fireMode == 0 then FireMode.ShootingDisable = true end

            -- If R was just pressed and client is not already reloading
            if IsDisabledControlJustPressed(1, 45) and not FireMode.Reloading then
                maxAmmo = GetMaxAmmoInClip(PlayerPedId(), FireMode.LastWeapon, 1)
                if maxAmmo ~= FireMode.Weapons[Active_Weapon].ammo then
                    FireMode.Reloading = true
                    FireMode.ShootingDisable = true
                    reload()
                end
            end

            if IsDisabledControlJustPressed(1, button)then
                -- If the fire mode is set to safety
                if FireMode.Weapons[Active_Weapon].fireMode == 0 then
                    PlaySoundFrontend(-1, "HACKING_MOVE_CURSOR", 0, 1)
                    -- If fire mode is set to semi-automatic
                elseif FireMode.Weapons[Active_Weapon].fireMode == 1 then
                    if not FireMode.ShootingDisable then
                        while IsDisabledControlPressed(1, button) do
                            DisablePlayerFiring(PlayerId(), true)
                            Citizen.Wait(0)
                        end
                    end
                    -- If fire mode is set to burst
                elseif FireMode.Weapons[Active_Weapon].fireMode == 2 then
                    if not FireMode.ShootingDisable then
                        Citizen.Wait(200)
                        while IsDisabledControlPressed(1, button) do
                            DisablePlayerFiring(PlayerId(), true)
                            Citizen.Wait(0)
                        end
                    end
                    -- If fire mode is set to full
                elseif FireMode.Weapons[Active_Weapon].fireMode == 3 then
                end
            end
            if IsDisabledControlJustReleased(1, button) then
                local clothes = getClothes(PlayerPedId())
                local coords = GetEntityCoords(PlayerPedId())
                local found, newZ = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z,false)
                coords = vector3(coords.x,coords.y,newZ - 0.2)
                TriggerServerEvent("weapons_scripts:server:shot", coords, FireMode.Weapons[Active_Weapon], clothes)
                TriggerServerEvent("inventory:setWeaponAmmo", Active_Weapon, current_ammo)
            end
        else
            if IsControlJustReleased(1, button) then
                weapon = GetSelectedPedWeapon(PlayerPedId())
                if Config.Tank[weapon] then
                    local _, Ammo = GetAmmoInClip(PlayerPedId(), weapon)
                    Wait(500)
                    TriggerServerEvent("inventory:setWeaponAmmo", weapon, Ammo)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Active and Active_Weapon then
            _, current_ammo = GetAmmoInClip(PlayerPedId(), Active_Weapon)
            FireMode.Weapons[Active_Weapon].ammo = current_ammo
            if (current_ammo == 1 and not breaked) then
                SetWeaponsNoAutoswap(1)
                SetWeaponsNoAutoreload(1)
                breaked = true
            elseif current_ammo > 1 and breaked then
                breaked = false
            else
                if FireMode.Weapons[Active_Weapon].fireMode ~= 0 then
                    if FireMode.ShootingDisable and not vehicle then
                        FireMode.ShootingDisable = false
                    end
                elseif FireMode.Weapons[Active_Weapon].fireMode == 0 then
                    FireMode.ShootingDisable = true
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 100
        if vehicle then timer = 10 end
        if not vehicle then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            end
        else
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                vehicle = false
            end
        end

        if vehicle then
            if DoesVehicleHaveWeapons(vehicle) then
                for _, weaponHash in each(Config.VehicleWeapons) do
                    DisableVehicleWeapon(true, weaponHash, vehicle, PlayerPedId())
                end
            end
        end

        if vehicle then
            --print(GetFollowVehicleCamViewMode(), type(GetFollowVehicleCamViewMode()))
            if GetFollowVehicleCamViewMode() == 4 then
                FireMode.ShootingDisable = false
                --print(FireMode.ShootingDisable)
            else
                FireMode.ShootingDisable = true
            end
        end
        Citizen.Wait(timer)
    end
end)

Citizen.CreateThread(function()
    while true do
        -- If weapon does not require reticle, remove reticle
        if Active and Active ~= "reticle" then HideHudComponentThisFrame(14) end
        -- Hide weapon icon
        HideHudComponentThisFrame(2)
        -- Hide weapon wheel stats
        HideHudComponentThisFrame(20)
        -- Hide hud weapons
        HideHudComponentThisFrame(22)

        if IsPedBeingStunned(PlayerPedId()) then
            SetPedMinGroundTimeForStungun(PlayerPedId(), 7000)
        end

        while FireMode.ShootingDisable do
            DisablePlayerFiring(PlayerId(), true)
            -- Disable reload and pistol whip
            --DisableControlAction(0, 24, true)
            --DisableControlAction(0, 69, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            Citizen.Wait(0)
        end

        if Active_Weapon then
            --DisableControlAction(0, 24, true)
            --DisableControlAction(0, 69, true)
            -- Disable reload and pistol whip
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            if IsPedShooting(PlayerPedId()) then
                shooting()
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterCommand(
        "changeFireRate",
        function()
            if Active then
                fire_ratio()
            end
        end,
        false
)

RegisterCommand(
        "aimingAnimation",
        function()
            if Active then
                TriggerServerEvent("weapons_scripts:server:animation", PlayerPedId())
            end
        end,
        false
)

createNewKeyMapping({command = "changeFireRate", text = "Odjištění / zajištění zbraně", key = "Z"})
createNewKeyMapping({command = "aimingAnimation", text = "Změna animace pro míření", key = "U"})

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end