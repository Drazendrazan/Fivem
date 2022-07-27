QBCore = nil

local charPed = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

Config = {
    PedCoords = {x = 414.61, y = -979.70, z = -99.00, h = 1.40, r = 1.0}, 
    HiddenCoords = {x = 404.61, y = -970.70, z = -99.00, h = 156.5, r = 1.0}, 
    CamCoords = {x = -814.02, y = 179.56, z = 76.74, h = 198.5, r = 1.0}, 
}

--- CODE

local choosingCharacter = false
local cam = nil

function openCharMenu(bool)
    print(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    choosingCharacter = bool
    skyCam(bool)
end

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-multicharacter:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI')
AddEventHandler('qb-multicharacter:client:closeNUI', function()
    SetNuiFocus(false, false)
end)

local Countdown = 1

RegisterNetEvent('qb-multicharacter:client:chooseChar')
AddEventHandler('qb-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    local interior = GetInteriorAtCoords(404.61, -970.70, -99.00)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Citizen.Wait(1000)
        print("[Loading Selector Interior, Please Wait!]")
    end
    FreezeEntityPosition(GetPlayerPed(-1), true)
    SetEntityCoords(GetPlayerPed(-1), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Citizen.Wait(1500)
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

function selectChar()
    openCharMenu(true)
end


RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData
	RequestModel(GetHashKey("mp_m_freemode_01"))

	while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
	    Wait(1)
    end
    
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)

    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
            if model ~= nil then
                model = model ~= nil and tonumber(model) or false

                if not IsModelInCdimage(model) or not IsModelValid(model) then setDefault() return end
            
                Citizen.CreateThread(function()
                    RequestModel(model)
            
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end

                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.h, false, true)
                    
                    data = json.decode(data)
            
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
                end)
            else
                charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.h, false, true)
            end
        end, cData.citizenid)
    else
        charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.h, false, true)
    end

    Citizen.Wait(100)
    
    SetEntityHeading(charPed, 189.5)
    FreezeEntityPosition(charPed, false)
    SetEntityInvincible(charPed, true)
    PlaceObjectOnGroundProperly(charPed)
    SetBlockingOfNonTemporaryEvents(charPed, true)
end)

RegisterNUICallback('setupCharacters', function()
    QBCore.Functions.TriggerCallback("test:yeet", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "man" then
        cData.gender = 0
    elseif cData.gender == "woman" then
        cData.gender = 1
    end

    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    TriggerServerEvent('qb-multicharacter:server:GiveStarterItems')
    Citizen.Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
end)

function skyCam(bool)
    SetRainFxIntensity(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(12, 0, 0)

    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 414.46, -977.70, -98.50, 1.4, 0.00, 180.00, 200.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end