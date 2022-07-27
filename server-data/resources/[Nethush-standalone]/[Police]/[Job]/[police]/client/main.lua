Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

isLoggedIn = true

isHandcuffed = false
cuffType = 1
isEscorted = false
draggerId = 0
PlayerJob = {}
onDuty = false

databankOpen = false

QBCore = nil
Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
    SetCarItemsInfo()
end)

Citizen.CreateThread(function()
    for k, station in pairs(Config.Locations["stations"]) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, 60)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 29)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Polcie Station")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("police:server:UpdateBlips")
        if JobInfo.name == "police" or JobInfo.name == "police1" or JobInfo.name == "police2" or JobInfo.name == "police3" or JobInfo.name == "police4" or JobInfo.name == "police5" or JobInfo.name == "police6" or JobInfo.name == "police7" or JobInfo.name == "police8" then
        if PlayerJob.onduty then
            TriggerServerEvent("QBCore:ToggleDuty")
            onDuty = false
        end
    end

    if (PlayerJob ~= nil) and PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = QBCore.Functions.GetPlayerData().job.onduty
    isHandcuffed = false
    TriggerServerEvent("QBCore:Server:SetMetaData", "ishandcuffed", false)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateBlips")
    TriggerServerEvent("police:server:UpdateCurrentCops")
    TriggerServerEvent("police:server:CheckBills")

    if QBCore.Functions.GetPlayerData().metadata["tracker"] then
        local trackerClothingData = {outfitData = {["accessory"] = { item = 13, texture = 0}}}
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    else
        local trackerClothingData = {outfitData = {["accessory"]   = { item = -1, texture = 0}}}
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    end

    if (PlayerJob ~= nil) and PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('police:client:sendBillingMail')
AddEventHandler('police:client:sendBillingMail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "sir"
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs."
        end
        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Central Judicial Collection Agency",
            subject = "Direct Debit",
            message = "Best " .. gender .. " " .. charinfo.lastname .. ",<br /><br />It Central Judicial Collection Agency (CJIB) charged the fines you received from the police. <br /> <strong> $ ".. amount .." </strong> has been deducted from your account. <br /> <br /> With kind regards, <br /> Mr. I. qb",
            button = {}
        })
    end)
end)

local tabletProp = nil
RegisterNetEvent('police:client:toggleDatabank')
AddEventHandler('police:client:toggleDatabank', function()
    databankOpen = not databankOpen
    if databankOpen then
        RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@base")
        while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@base") do
            Citizen.Wait(0)
        end
        local tabletModel = GetHashKey("prop_cs_tablet")
        local bone = GetPedBoneIndex(GetPlayerPed(-1), 60309)
        RequestModel(tabletModel)
        while not HasModelLoaded(tabletModel) do
            Citizen.Wait(100)
        end
        tabletProp = CreateObject(tabletModel, 1.0, 1.0, 1.0, 1, 1, 0)
        AttachEntityToEntity(tabletProp, GetPlayerPed(-1), bone, 0.03, 0.002, -0.0, 10.0, 160.0, 0.0, 1, 0, 0, 0, 2, 1)
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "databank",
        })
    else
        DetachEntity(tabletProp, true, true)
        DeleteObject(tabletProp)
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closedatabank",
        })
    end
end)


RegisterNUICallback("closeDatabank", function(data, cb)
    databankOpen = false
    DetachEntity(tabletProp, true, true)
    DeleteObject(tabletProp)
    SetNuiFocus(false, false)
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('police:server:UpdateBlips')
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateCurrentCops")
    isLoggedIn = false
    isHandcuffed = false
    isEscorted = false
    onDuty = false
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
    if DutyBlips ~= nil then 
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
end)

local DutyBlips = {}
RegisterNetEvent('police:client:UpdateBlips')
AddEventHandler('police:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' or PlayerJob.name == 'ems' or PlayerJob.name == 'ems1'or PlayerJob.name == 'ems2' or PlayerJob.name == 'ems3' or PlayerJob.name == 'ems4' or PlayerJob.name == 'ems5' or PlayerJob.name == 'ems6' or PlayerJob.name == 'ems7' or PlayerJob.name == 'ems8') and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
	local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
        SetBlipScale(blip, 1.0)
        if playerJob == "police" or playerJob == "police2" or playerJob == "police3" or playerJob == "police4" or playerJob == "police5" or playerJob == "police6" or playerJob == "police7" or playerJob == "police8" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 5)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		
		table.insert(DutyBlips, blip)
	end
end

RegisterNetEvent('police:client:SendPoliceEmergencyAlert')
AddEventHandler('police:client:SendPoliceEmergencyAlert', function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end
    local alertTitle = "Assistance colleague"
    if PlayerJob.name == "ambulance" or PlayerJob.name == "police" or PlayerJob.name == "ems2" or PlayerJob.name == "ems3" or PlayerJob.name == "ems4"  or PlayerJob.name == "ems5"  or PlayerJob.name == "ems6" or PlayerJob.name == "ems7"  or PlayerJob.name == "ems8" then
        alertTitle = "Assistance " .. PlayerJob.label
    end

    local MyId = GetPlayerServerId(PlayerId())

    TriggerServerEvent("police:server:SendPoliceEmergencyAlert", streetLabel, pos, QBCore.Functions.GetPlayerData().metadata["callsign"])
    TriggerServerEvent('qb-policealerts:server:AddPoliceAlert', {
        timeOut = 10000,
        alertTitle = alertTitle,
        coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-passport"></i>',
                detail = MyId .. ' | ' .. QBCore.Functions.GetPlayerData().charinfo.firstname .. ' ' .. QBCore.Functions.GetPlayerData().charinfo.lastname,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = streetLabel,
            },
        },
        callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
    }, true)
end)
RegisterNetEvent('qb-police:client:send:alert:panic:button')
AddEventHandler('qb-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty or (QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Emergency Button",
            priority = 3,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-13C',
        })
        AddAlert('Emergency Button', 487, 250, Coords, false)
    end
end)

RegisterNetEvent('qb-police:client:send:bank:alert')
AddEventHandler('qb-police:client:send:bank:alert', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Fleeca Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, false)
        AddAlert('Fleeca Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:big:bank:alert')
AddEventHandler('qb-police:client:send:big:bank:alert', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Pacific Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
                [2] = {
                    icon = '<i class="fas fa-university"></i>',
                    detail = "Pacific RobbERy Progress",
                },
            },
            callSign = '10-35A',
        }, false)
        AddAlert('Pacific Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:store')
AddEventHandler('qb-police:client:send:alert:store', function(streetName, CCTV)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Store Alarm",
        priority = 0,
        details = {
            [1] = {
                icon = '<i class="fas fa-video"></i>',
                detail = 'CCTV: '..CCTV,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = streetName,
            },
        },
        callSign = '10-98A',
    }, false)
    AddAlert2('Store Alarm', 59, 250, false, true)
 end
end)

RegisterNetEvent('police:client:ParkingRobberyCall')
AddEventHandler('police:client:ParkingRobberyCall', function(coords, msg, gender, streetLabel)
    if PlayerJob.name == 'police' and onDuty then
        TriggerEvent('qb-policealerts:server:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "Parking meter robbery",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-venus-mars"></i>',
                    detail = gender,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 411)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Report: Parking meter")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)


RegisterNetEvent('police:PlaySound')
AddEventHandler('police:PlaySound', function()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:PoliceEmergencyAlert')
AddEventHandler('police:client:PoliceEmergencyAlert', function(callsign, streetLabel, coords)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' or PlayerJob.name == 'ems' or PlayerJob.name == 'ems1'or PlayerJob.name == 'ems2' or PlayerJob.name == 'ems3'or PlayerJob.name == 'ems4' or PlayerJob.name == 'ems5'or PlayerJob.name == 'ems6' or PlayerJob.name == 'ems7'or PlayerJob.name == 'ems8') and onDuty then
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Assistance colleague")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

--[[RegisterNetEvent('police:client:GunShotAlert')
AddEventHandler('police:client:GunShotAlert', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then        
        local msg = ""
        local blipSprite = 313
        local blipText = "Shots fired"
        local MessageDetails = {}
        if fromVehicle then
            blipText = "Shots fired from vehicle"
            MessageDetails = {
                [1] = {
                    icon = '<i class="fas fa-car"></i>',
                    detail = vehicleInfo.name,
                },
                [2] = {
                    icon = '<i class="fas fa-closed-captioning"></i>',
                    detail = vehicleInfo.plate,
                },
                [3] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            }
        else
            blipText = "Shots fired"
            MessageDetails = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            }
        end
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "iFruit Store",
            priority = 0,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
                [2] = {
                    icon = '<i class="fas fa-university"></i>',
                    detail = "Possible robbery attempt",
                },
            },
            callSign = '10-31A',
        }, false)
        AddAlert('Robbery', 457, 250, Coords, false, false)

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, blipSprite)
        SetBlipColour(blip, 0)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipText)
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)]]

RegisterNetEvent('police:client:VehicleCall')
AddEventHandler('police:client:VehicleCall', function(pos, alertTitle, streetLabel, modelPlate, modelName)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then
        TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            timeOut = 4000,
            alertTitle = alertTitle,
            coords = {
                x = pos.x,
                y = pos.y,
                z = pos.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-car"></i>',
                    detail = modelName,
                },
                [2] = {
                    icon = '<i class="fas fa-closed-captioning"></i>',
                    detail = modelPlate,
                },
                [3] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 380)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Notification: Vehicle break-in")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:client:ArobCall')
AddEventHandler('police:client:ArobCall', function(coords, msg,streetLabel)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then
        TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            timeOut = 4000,
            alertTitle = "Atm Robbery Progress",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-car"></i>',
                    detail = msg,
                },
                [2] = {
                    icon = '<i class="fas fa-closed-captioning"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 380)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Notification: AtmRobbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)


RegisterNetEvent('police:client:HouseRobberyCall')
AddEventHandler('police:client:HouseRobberyCall', function(coords, msg, gender, streetLabel)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then
        TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "House Robbery",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-venus-mars"></i>',
                    detail = gender,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 411)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Notification: Burglary house")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

-- RegisterNetEvent('911:client:SendPoliceAlert')
-- AddEventHandler('911:client:SendPoliceAlert', function(notifyType, data, blipSettings)
    -- if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then
        -- if notifyType == "flagged" then
            -- TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
                -- timeOut = 5000,
                -- alertTitle = "House Robbery",
                -- details = {
                    -- [1] = {
                        -- icon = '<i class="fas fa-video"></i>',
                        -- detail = data.camId,
                    -- },
                    -- [2] = {
                        -- icon = '<i class="fas fa-closed-captioning"></i>',
                        -- detail = data.plate,
                    -- },
                    -- [3] = {
                        -- icon = '<i class="fas fa-globe-europe"></i>',
                        -- detail = data.streetLabel,
                    -- },
                -- },
                -- callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
            -- })
            -- RadarSound()
        -- end
    
        -- if blipSettings ~= nil then
            -- local transG = 250
            -- local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            -- SetBlipSprite(blip, blipSettings.sprite)
            -- SetBlipColour(blip, blipSettings.color)
            -- SetBlipDisplay(blip, 4)
            -- SetBlipAlpha(blip, transG)
            -- SetBlipScale(blip, blipSettings.scale)
            -- SetBlipAsShortRange(blip, false)
            -- BeginTextCommandSetBlipName('STRING')
            -- AddTextComponentString(blipSettings.text)
            -- EndTextCommandSetBlipName(blip)
            -- while transG ~= 0 do
                -- Wait(180 * 4)
                -- transG = transG - 1
                -- SetBlipAlpha(blip, transG)
                -- if transG == 0 then
                    -- SetBlipSprite(blip, 2)
                    -- RemoveBlip(blip)
                    -- return
                -- end
            -- end
        -- end
    -- end
-- end)

-- RegisterNetEvent('police:client:PoliceAlertMessage')
-- AddEventHandler('police:client:PoliceAlertMessage', function(title, streetLabel, coords)
    -- if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8') and onDuty then
        -- TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            -- timeOut = 5000,
            -- alertTitle = title,
            -- details = {
                -- [1] = {
                    -- icon = '<i class="fas fa-globe-europe"></i>',
                    -- detail = streetLabel,
                -- },
            -- },
            -- callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        -- })

        -- PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        -- local transG = 100
        -- local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        -- SetBlipSprite(blip, 9)
        -- SetBlipColour(blip, 1)
        -- SetBlipAlpha(blip, transG)
        -- SetBlipAsShortRange(blip, false)
        -- BeginTextCommandSetBlipName('STRING')
        -- AddTextComponentString("911 - "..title)
        -- EndTextCommandSetBlipName(blip)
        -- while transG ~= 0 do
            -- Wait(180 * 4)
            -- transG = transG - 1
            -- SetBlipAlpha(blip, transG)
            -- if transG == 0 then
                -- SetBlipSprite(blip, 2)
                -- RemoveBlip(blip)
                -- return
            -- end
        -- end
    -- end
-- end)

-- RegisterNetEvent('police:server:SendEmergencyMessageCheck')
-- AddEventHandler('police:server:SendEmergencyMessageCheck', function(MainPlayer, message, coords)
    -- local PlayerData = QBCore.Functions.GetPlayerData()
    -- if ((PlayerData.Job.name == 'police' or PlayerData.Job.name == 'police1' or PlayerData.Job.name == 'police2' or PlayerData.Job.name == 'police3' or PlayerData.Job.name == 'police4' or PlayerData.Job.name == 'police5' or PlayerData.Job.name == 'police6' or PlayerData.Job.name == 'police7' or PlayerData.Job.name == 'police8' or PlayerData.Job.name == 'ems' or PlayerData.Job.name == 'ems1' or PlayerData.Job.name == 'ems2' or PlayerData.Job.name == 'ems3' or PlayerData.Job.name == 'ems4' or PlayerData.Job.name == 'ems5' or PlayerData.Job.name == 'ems6' or PlayerData.Job.name == 'ems7' or PlayerData.Job.name == 'ems8') and onDuty) then
        -- TriggerEvent('chatMessage', "911 Notification - " .. MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..MainPlayer.PlayerData.source..")", "warning", message)
        -- TriggerEvent("police:client:EmergencySound")
        -- local transG = 250
        -- local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        -- SetBlipSprite(blip, 280)
        -- SetBlipColour(blip, 4)
        -- SetBlipDisplay(blip, 4)
        -- SetBlipAlpha(blip, transG)
        -- SetBlipScale(blip, 0.9)
        -- SetBlipAsShortRange(blip, false)
        -- BeginTextCommandSetBlipName('STRING')
        -- AddTextComponentString("911 Notification")
        -- EndTextCommandSetBlipName(blip)
        -- while transG ~= 0 do
            -- Wait(180 * 4)
            -- transG = transG - 1
            -- SetBlipAlpha(blip, transG)
            -- if transG == 0 then
                -- SetBlipSprite(blip, 2)
                -- RemoveBlip(blip)
                -- return
            -- end
        -- end
    -- end
-- end)

-- RegisterNetEvent('police:client:Send911AMessage')
-- AddEventHandler('police:client:Send911AMessage', function(message)
    -- local PlayerData = QBCore.Functions.GetPlayerData()
    -- if ((PlayerData.Job.name == 'police' or PlayerData.Job.name == 'police1' or PlayerData.Job.name == 'police2' or PlayerData.Job.name == 'police3' or PlayerData.Job.name == 'police4' or PlayerData.Job.name == 'police5' or PlayerData.Job.name == 'police6' or PlayerData.Job.name == 'police7' or PlayerData.Job.name == 'police8' or PlayerData.Job.name == 'ems' or PlayerData.Job.name == 'ems1' or PlayerData.Job.name == 'ems2' or PlayerData.Job.name == 'ems3' or PlayerData.Job.name == 'ems4' or PlayerData.Job.name == 'ems5' or PlayerData.Job.name == 'ems6' or PlayerData.Job.name == 'ems7' or PlayerData.Job.name == 'ems8') and onDuty) then
        -- TriggerEvent('chatMessage', "ANONYMOUS Notification", "warning", message)
        -- TriggerEvent("police:client:EmergencySound")
    -- end
-- end)

RegisterNetEvent('911:client:SendPoliceAlert')
AddEventHandler('911:client:SendPoliceAlert', function(notifyType, msg, type, blipSettings)
    if PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' or PlayerJob.name == 'ems' or PlayerJob.name == 'ems1' or PlayerJob.name == 'ems2' or PlayerJob.name == 'ems3' or PlayerJob.name == 'ems4' or PlayerJob.name == 'ems5' or PlayerJob.name == 'ems6' or PlayerJob.name == 'ems7' or PlayerJob.name == 'ems8' and onDuty then
        if notifyType == "flagged" then
            TriggerEvent("chatMessage", "MESSAGE", "error", msg)
            RadarSound()
        elseif notifyType == "player" then
            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
        else
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "911-MESSAGE", "error", msg)
        end
    
        if blipSettings ~= nil then
            local transG = 250
            local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            SetBlipSprite(blip, blipSettings.sprite)
            SetBlipColour(blip, blipSettings.color)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, transG)
            SetBlipScale(blip, blipSettings.scale)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipSettings.text)
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent('police:client:PoliceAlertMessage')
AddEventHandler('police:client:PoliceAlertMessage', function(msg, coords)
    if PlayerJob.name == 'police' or PlayerJob.name == 'police1' or PlayerJob.name == 'police2' or PlayerJob.name == 'police3' or PlayerJob.name == 'police4' or PlayerJob.name == 'police5' or PlayerJob.name == 'police6' or PlayerJob.name == 'police7' or PlayerJob.name == 'police8' or PlayerJob.name == 'ems' or PlayerJob.name == 'ems1' or PlayerJob.name == 'ems2' or PlayerJob.name == 'ems3' or PlayerJob.name == 'ems4' or PlayerJob.name == 'ems5' or PlayerJob.name == 'ems6' or PlayerJob.name == 'ems7' or PlayerJob.name == 'ems8' and onDuty then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("chatMessage", "911-MESSAGE", "error", msg)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("911 - Verdachte situatie ")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('qb-police:client:send:officer:down')
AddEventHandler('qb-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        local Title, Callsign = 'Officer down', '10-13B'
        if Priority == 3 then
            Title, Callsign = 'Officer down (Urgent)', '10-13A'
        end
        TriggerEvent('lerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = Title,
            priority = Priority,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = Callsign,
        }, false)
        AddAlert(Title, 306, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:dead')
AddEventHandler('qb-police:client:send:alert:dead', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Injured Citizen",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Injured Citizen', 480, 250, Coords, false)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:yachtrob')
AddEventHandler('qb-police:client:send:alert:yachtrob', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "police1") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Yacht Robbery",
            priority = 2,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Yacht Robbery', 617, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:storerob')
AddEventHandler('qb-police:client:send:alert:storerob', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "police1") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Store Robbery",
            priority = 2,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
                [2] = {
                    icon = '<i class="fas fa-university"></i>',
                    detail = "Store Complitly Down",
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert2('Store Alarm', 59, 250, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:houser')
AddEventHandler('qb-police:client:send:alert:houser', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "police1") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "House Robbery",
            priority = 2,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
                [2] = {
                    icon = '<i class="fas fa-university"></i>',
                    detail = "House Complitly Down",
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('House Alarm', 40, 250, Coords, false, false)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:ammunation')
AddEventHandler('qb-police:client:send:alert:ammunation', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Ammu Nation",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, false)
AddAlert('Ammu Nation', 617, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:house:alert')
AddEventHandler('qb-police:client:send:house:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "House Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-63B',
    }, false)
    AddAlert('House Alarm', 40, 250, Coords, false, false)
 end
end)

RegisterNetEvent('qb-police:client:send:house2:alert')
AddEventHandler('qb-police:client:send:house2:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "ATM Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Loud Explosion Heard",
            },
        },
        callSign = '10-31A',
    }, false)
    AddAlert('Cash Machine', 486, 250, Coords, false, false)
 end
end)

RegisterNetEvent('qb-police:client:send:alert:atmro')
AddEventHandler('qb-police:client:send:alert:atmro', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "police1") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('nethush-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "ATM Robbery",
            priority = 2,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
                [2] = {
                    icon = '<i class="fas fa-university"></i>',
                    detail = "ATM Complitly Down",
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Cash Machine', 486, 250, Coords, false, false)
    end
end)

RegisterNetEvent('qb-police:client:send:house3:alert')
AddEventHandler('qb-police:client:send:house3:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "iFruit Store",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Possible robbery attempt",
            },
        },
        callSign = '10-31A',
    }, false)
    AddAlert('Robbery', 457, 250, Coords, false, false)
 end
end)

RegisterNetEvent('qb-police:client:send:house4:alert')
AddEventHandler('qb-police:client:send:house4:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Humane Labs",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Loud Explosion Heard",
            },
        },
        callSign = '10-63B',
    }, false)
    AddAlert('Humane Labs', 486, 250, Coords, false, false)
 end
end)

RegisterNetEvent('qb-police:client:send:banktruck:alert')
AddEventHandler('qb-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Bank Truck Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'License Plate: '..Plate,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-03A',
    }, false)
    AddAlert('Bank Truck Alarm', 67, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:explosion:alert')
AddEventHandler('qb-police:client:send:explosion:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Explosion Alert",
        priority = 2,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-02C',
    }, false)
    AddAlert('Explosion', 630, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:cornerselling:alert')
AddEventHandler('qb-police:client:send:cornerselling:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Suspicious Acticity",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-16A',
    }, false)
    AddAlert('Suspicious Activity', 465, 250, Coords, false, true)
 end
end)

RegisterNetEvent('police:server:SendEmergencyMessageCheck')
AddEventHandler('police:server:SendEmergencyMessageCheck', function(MainPlayer, message, coords)
    local PlayerData = QBCore.Functions.GetPlayerData()

    if ((PlayerData.job.name == "police" or PlayerData.job.name == "police1" or PlayerData.job.name == "police2" or PlayerData.job.name == "police3" or PlayerData.job.name == "police4" or PlayerData.job.name == "police5" or PlayerData.job.name == "police6" or PlayerData.job.name == "police7" or PlayerData.job.name == "police8" or PlayerData.job.name == "ems" or PlayerData.job.name == "ems1" or PlayerData.job.name == "ems2" or PlayerData.job.name == "ems4" or PlayerData.job.name == "ems3" or PlayerData.job.name == "ems7" or PlayerData.job.name == "ems4" or PlayerData.job.name == "ems5" or PlayerData.job.name == "ems6" or PlayerData.job.name == "ems7" or PlayerData.job.name == "ems8") and onDuty) then
        TriggerEvent('chatMessage', "911 MESSAGE - " .. MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..MainPlayer.PlayerData.source..")", "warning", message)
        TriggerEvent("police:client:EmergencySound")
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 280)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.9)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("911 Message")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('qb-police:client:send:alert:gunshots')
AddEventHandler('qb-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
     local AlertMessage, CallSign = 'Shots fired', '10-47A'
     if InVeh then
         AlertMessage, CallSign = 'Shots fired from vehicle', '10-47B'
     end
     TriggerEvent('nethush-alerts:client:send:alert', {
        timeOut = 7500,
        alertTitle = AlertMessage,
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="far fa-arrow-alt-circle-right"></i>',
                detail = GunType,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = CallSign,
    }, false)
    AddAlert(AlertMessage, 313, 250, Coords, false, true)
  end
end)

RegisterNetEvent('police:client:Send911AMessage')
AddEventHandler('police:client:Send911AMessage', function(message)
    local PlayerData = QBCore.Functions.GetPlayerData()

    if ((PlayerData.job.name == "police" or PlayerData.job.name == "police1" or PlayerData.job.name == "police2" or PlayerData.job.name == "police3" or PlayerData.job.name == "police4" or PlayerData.job.name == "police5" or PlayerData.job.name == "police6" or PlayerData.job.name == "police7" or PlayerData.job.name == "police8" or PlayerData.job.name == "ems" or PlayerData.job.name == "ems1" or PlayerData.job.name == "ems2" or PlayerData.job.name == "ems4" or PlayerData.job.name == "ems3" or PlayerData.job.name == "ems7" or PlayerData.job.name == "ems4" or PlayerData.job.name == "ems5" or PlayerData.job.name == "ems6" or PlayerData.job.name == "ems7" or PlayerData.job.name == "ems8") and onDuty) then
        TriggerEvent('chatMessage', "ANONIEME MESSAGE", "warning", message)
        TriggerEvent("police:client:EmergencySound")
    end
end)

RegisterNetEvent('police:client:SendToJail')
AddEventHandler('police:client:SendToJail', function(time)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    isHandcuffed = false
    isEscorted = false
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
    TriggerEvent("prison:client:Enter", time)
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker)
    local Transition = Transition
    local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(Blips, Sprite)
    SetBlipColour(Blips, 6)
    SetBlipDisplay(Blips, 4)
    SetBlipAlpha(Blips, transG)
    SetBlipScale(Blips, 1.0)
    SetBlipAsShortRange(Blips, false)
   if Flashing then
    SetBlipFlashes(Blips, true)
   end
    BeginTextCommandSetBlipName('STRING')
    if not Tracker then
     AddTextComponentString('Alert: '..Text)
    else
     AddTextComponentString(Text)
    end
    EndTextCommandSetBlipName(Blips)
    while Transition ~= 0 do
        Wait(180 * 4)
        Transition = Transition - 1
        SetBlipAlpha(Blips, Transition)
        if Transition == 0 then
            SetBlipSprite(Blips, 2)
            RemoveBlip(Blips)
            return
        end
    end
   end
   function AddAlert2(Text, Sprite, Transition, Tracker)
       local Transition = Transition
       BeginTextCommandSetBlipName('STRING')
       if not Tracker then
        AddTextComponentString('Alert: '..Text)
       else
        AddTextComponentString(Text)
       end
   end

function RadarSound()
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)   
end

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        --local factor = (string.len(text)) / 370
		--DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
      end
  end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end 

RegisterNetEvent('qb-police:client:set:escort:status:false')
AddEventHandler('qb-police:client:set:escort:status:false', function()
 if Config.IsEscorted then
  Config.IsEscorted = false
  DetachEntity(PlayerPedId(), true, false)
  ClearPedTasks(PlayerPedId())
 end
end)

RegisterNetEvent('nethush-police:client:escort:closest')
AddEventHandler('nethush-police:client:escort:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
          if not IsPedInAnyVehicle(PlayerPedId()) then
            TriggerServerEvent("nethush-police:server:escort:closest", ServerId)
        else
         TriggerEvent("swt_notifications:Infos","You cant escort in a vehicle")
       end
     end
    else
        TriggerEvent("swt_notifications:Infos","Nobody nearby")
    end
end)

RegisterNetEvent('nethush-police:client:PutPlayerInVehicle')
AddEventHandler('nethush-police:client:PutPlayerInVehicle', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted  then
            TriggerServerEvent("nethush-police:server:set:in:veh", ServerId)
        end
    else
        TriggerEvent("swt_notifications:Infos","Nobody nearby")
    end
end)

RegisterNetEvent('nethush-police:client:SetPlayerOutVehicle')
AddEventHandler('nethush-police:client:SetPlayerOutVehicle', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            TriggerServerEvent("nethush-police:server:set:out:veh", ServerId)
        end
    else
        TriggerEvent("swt_notifications:Infos","Nobody nearby")
    end
end)

RegisterNetEvent('nethush-police:client:set:out:veh')
AddEventHandler('nethush-police:client:set:out:veh', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
    end
end)

RegisterNetEvent('nethush-police:client:set:in:veh')
AddEventHandler('nethush-police:client:set:in:veh', function()
    if Config.IsHandCuffed or Config.IsEscorted then
        local vehicle = QBCore.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), -1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    Config.IsEscorted = false
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)
                    Citizen.Wait(100)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('nethush-police:client:steal:closest')
AddEventHandler('nethush-police:client:steal:closest', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            QBCore.Functions.TriggerCallback('nethush-police:server:is:inventory:disabled', function(IsDisabled)
                if not IsDisabled then
                    QBCore.Functions.Progressbar("robbing_player", "Stealing stuff..", math.random(5000, 7000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
            }, {
                animDict = "random@shop_robbery",
                anim = "robbery_action_b",
                flags = 16,
            }, {}, {}, function() -- Done
                local plyCoords = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                if dist < 2.5 then
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                    TriggerServerEvent("nethush-inventory:server:OpenInventory", "otherplayer", playerId)
                    TriggerEvent("nethush-inventory:server:RobPlayer", playerId)
                else
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                    TriggerEvent("swt_notifications:Infos","Nobody nearby")
                end
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                TriggerEvent("swt_notifications:Infos","Cancelled..")
            end)
        else
            TriggerEvent("swt_notifications:Infos","Too bad you cant rob eh puto")
        end
    end, playerId)
        end
    else
        TriggerEvent("swt_notifications:Infos","Nobody nearby")
    end
end)
