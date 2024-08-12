ESX = exports["es_extended"]:getSharedObject() -- esx legacy


local weaponCheckInterval = 1000
local isMonitoringAmmo = false

function MonitorAmmo()
    CreateThread(function()
        local currentWeapon = { Ammo = 0 }
        
        while isMonitoringAmmo do
            local ped = ESX.PlayerData.ped
            local selectedWeapon = GetSelectedPedWeapon(ped)
            
            if selectedWeapon ~= -1569615261 then -- Wenn Waffe ausgewählt und nicht Faust
                local _, weaponHash = GetCurrentPedWeapon(ped, true)
                local weapon = ESX.GetWeaponFromHash(weaponHash)

                if weapon then
                    local ammoCount = GetAmmoInPedWeapon(ped, weaponHash)
                    if weapon.name ~= currentWeapon.name then
                        currentWeapon.Ammo = ammoCount
                        currentWeapon.name = weapon.name
                    elseif ammoCount ~= currentWeapon.Ammo then
                        currentWeapon.Ammo = ammoCount
                        TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
                    end
                end

                Wait(1000)
            else
                isMonitoringAmmo = false
                print(2)
                break
            end
        end
    end)
end

CreateThread(function()
    while ESX.PlayerLoaded do
        local ped = ESX.PlayerData.ped
        local selectedWeapon = GetSelectedPedWeapon(ped)

        if selectedWeapon ~= -1569615261 and not isMonitoringAmmo then
            print(1)
            isMonitoringAmmo = true
            MonitorAmmo()
        end
        
        Wait(weaponCheckInterval)
    end
end)
