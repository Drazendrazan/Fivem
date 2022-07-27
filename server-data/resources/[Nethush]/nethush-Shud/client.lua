local Config = {}
--SET TO TRUE IF YOU ARE USING B1G_HUD
Config.isbighud = true
isLoggedIn = true
stress = 0
PlayerJob = {}

local toghud = false

local loaded = false
local hunger = 100
local thirst = 100

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(10)
    end
  end
)
RegisterCommand('hud', function(source, args, rawCommand)
    toghud = not toghud
    TriggerEvent('hud:toggleui', toghud)
    TriggerEvent('carhud', toghud)
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	toghud = true
    showhud()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

local toghud = true
local StressGain = 0
local IsGaining = false

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)

        if IsPedShooting(GetPlayerPed(-1)) then
            local StressChance = math.random(1, 3)
            local odd = math.random(1, 3)
            if StressChance == odd then
                local PlusStress = math.random(2, 4) / 100
                StressGain = StressGain + PlusStress
            end
            if not IsGaining then
                IsGaining = true
            end
        else
            if IsGaining then
                IsGaining = false
            end
        end

        if (PlayerJob.name ~= "police") then
            if IsPlayerFreeAiming(PlayerId()) and not IsPedShooting(GetPlayerPed(-1)) then
                local CurrentWeapon = GetSelectedPedWeapon(ped)
                local WeaponData = QBCore.Shared.Weapons[CurrentWeapon]
                if WeaponData.name:upper() ~= "WEAPON_UNARMED" then
                    local StressChance = math.random(1, 20)
                    local odd = math.random(1, 20)
                    if StressChance == odd then
                        local PlusStress = math.random(1, 3) / 100
                        StressGain = StressGain + PlusStress
                    end
                end
                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end
        end

        Citizen.Wait(2)
    end
end)

RegisterNetEvent('hud:client:UpdateStress')
AddEventHandler('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                --TriggerEvent('swt_notifications:Infos','You get stressed', "primary", 2000)
                TriggerEvent("swt_notifications:Warning","SLMC System","You get stressed","top-right",2500,true)
                TriggerServerEvent('qb-hud:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end

        Citizen.Wait(3000)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(QBStress.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(QBStress.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local Wait = GetEffectInterval(stress)
        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                local player = PlayerPedId()
                SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Citizen.Wait(500)
            for i = 1, FallRepeat, 1 do
                Citizen.Wait(750)
                DoScreenFadeOut(200)
                Citizen.Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif stress >= QBStress.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
end)
Citizen.CreateThread(function()
    while true do
        if QBCore ~= nil and isLoggedIn and QBHud.Show then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
                if speed >= QBStress.MinimumSpeed then
                    TriggerServerEvent('qb-hud:Server:GainStress', math.random(1, 2))
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

RegisterNetEvent('qb-hud:toggleHud')
AddEventHandler('qb-hud:toggleHud', function(toggleHud1)
    toghud = not toghud
    TriggerEvent('hud:toggleui', toghud)
    TriggerEvent('carhud', toghud)
end)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)
    if show == true then
        toghud = true
        showhud()
    else
        toghud = false
    end
end)

function showhud()
    local player = PlayerPedId()
    local health = (GetEntityHealth(player) - 100)
    local armor = GetPedArmour(player)
    local oxy = nil
   -- startUpdate()
    while toghud do
        Citizen.Wait(200)
        player = PlayerPedId()
        health = (GetEntityHealth(player) - 100)
        armor = GetPedArmour(player)
        if IsPedOnFoot(player) then
            if IsPedSwimmingUnderWater(player) then
                oxy = (GetPlayerUnderwaterTimeRemaining(PlayerId())*10)
                if oxy <= 0.0 and health >= 1 then
                    SetEntityHealth(player, 0)
                end
            else
                oxy = 100.0 - (GetPlayerSprintStaminaRemaining(PlayerId()))
            end
        else
            oxy = 0
        end
        if not IsPauseMenuActive() then
            SendNUIMessage({
                action = 'updateStatusHud',
                isCar = IsPedInAnyVehicle(player, false) and IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) and Config.isbighud == true,
                show = toghud,
                health = health,
                armour = armor,
                oxygen = oxy,
                hunger = hunger,
                thirst = thirst,
                stress = stress,
            })
        else
            SendNUIMessage({
                action = 'updateStatusHud',
                show = false,
            })
        end
    end
end

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)