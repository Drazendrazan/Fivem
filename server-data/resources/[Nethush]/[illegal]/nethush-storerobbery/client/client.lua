local OpeningRegister = false
local CurrentSafe, NearSafe = nil, false
local CurrentRegister, NearRegister = nil, false
local CurrentCops = 0

local PlayerJob = {}
local onDuty = false

local isLoggedIn = false

QBCore = nil

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
      Citizen.Wait(100)
      QBCore.Functions.TriggerCallback("nethush-storerobbery:server:get:config", function(ConfigData)
        Config = ConfigData
      end)
      isLoggedIn = true
  end)
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('qb-police:SetCopCount')
AddEventHandler('qb-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

Citizen.CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData().job ~= nil and next(QBCore.Functions.GetPlayerData().job) then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

-- Code

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearRegister = false
            for k, v in pairs(Config.Registers) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                  NearRegister = true
                  CurrentRegister = k
                  if v['Robbed'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], '~r~Register is empty...')
                  elseif v['Busy'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], '~o~Robbing Register..')
                  end
               end
            end
            if not NearRegister then
                Citizen.Wait(1500)
                CurrentRegister = nil
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearSafe = false
            for k, v in pairs(Config.Safes) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.5 then
                    NearSafe = true
                    CurrentSafe = k
                    if v['Robbed'] then
                      DrawText3D(v['X'], v['Y'], v['Z'], '~r~Safe is empty...')
                    elseif v['Busy'] then
                      DrawText3D(v['X'], v['Y'], v['Z'], '~o~Robbing safe..')
                    end
                end
            end
             if not NearSafe then
                 Citizen.Wait(1500)
                 CurrentSafe = nil
             end
        else
           Citizen.Wait(1500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('nethush-storerobbery:client:set:register:robbed')
AddEventHandler('nethush-storerobbery:client:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
end)

RegisterNetEvent('nethush-storerobbery:client:set:register:busy')
AddEventHandler('nethush-storerobbery:client:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
end)

RegisterNetEvent('nethush-storerobbery:client:safe:busy')
AddEventHandler('nethush-storerobbery:client:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
end)

RegisterNetEvent('nethush-storerobbery:client:safe:robbed')
AddEventHandler('nethush-storerobbery:client:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
end)

RegisterNetEvent('nethush-items:client:use:lockpick')
AddEventHandler('nethush-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if NearRegister then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Registers[CurrentRegister]['X'], Config.Registers[CurrentRegister]['Y'], Config.Registers[CurrentRegister]['Z'], true)
        if Distance < 1.3 and not Config.Registers[CurrentRegister]['Robbed'] then
         if CurrentCops >= Config.PoliceNeeded then
                if IsAdvanced then
                    LockPickRegister(CurrentRegister, IsAdvanced)
                else
                    QBCore.Functions.TriggerCallback('nethush-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            LockPickRegister(CurrentRegister, IsAdvanced)
                        else
                            TriggerEvent("swt_notifications:Infos","You are missing something")
                        end
                    end, "toolkit") 
                end
            else
                TriggerEvent("swt_notifications:Infos","Not enough cops ("..Config.PoliceNeeded.." Needed)", "info")
            end
        end
    elseif NearSafe then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Safes[CurrentSafe]['X'], Config.Safes[CurrentSafe]['Y'], Config.Safes[CurrentSafe]['Z'], true)
        if Distance < 1.3 and not Config.Safes[CurrentSafe]['Robbed'] then
            if CurrentCops >= Config.PoliceNeeded then
                if IsAdvanced then
                    CrackSafe(CurrentSafe, IsAdvanced)
                else
                    QBCore.Functions.TriggerCallback('nethush-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            CrackSafe(CurrentSafe, IsAdvanced)
                        else
                            TriggerEvent("swt_notifications:Infos","You are missing something")
                        end
                    end, "toolkit") 
                end
            else
                TriggerEvent("swt_notifications:Infos","Not enough cops ("..Config.PoliceNeeded.." Needed)", "info")
            end
        end

    end
end)

-- Function

function LockPickRegister(RegisterId, IsAdvanced)
 local LockPickTime = math.random(15000, 25000)
 if not IsWearingHandshoes() then
    local pos = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent("evidence:server:CreateFingerDrop", pos) 
end

 if math.random(1,10) < 9 then
    local StreetLabel = QBCore.Functions.GetStreetLabel()
    TriggerServerEvent("qb-police:server:send:alert:storerob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
end

 TriggerServerEvent('nethush-storerobbery:server:set:register:busy', RegisterId, true)
 exports['nethush-lockpick']:OpenLockpickGame(function(Success)
     if Success then
         LockPickRegisterAnim(LockPickTime)
         local StreetLabel = QBCore.Functions.GetStreetLabel()
         TriggerServerEvent("qb-police:server:send:alert:storerob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
         TriggerServerEvent('nethush-storerobbery:server:set:register:robbed', RegisterId, true)
         TriggerServerEvent('nethush-storerobbery:server:set:register:busy', RegisterId, false)
         QBCore.Functions.Progressbar("search_register", "Robbing Register..", LockPickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done    
            OpeningRegister = false
            TriggerServerEvent('nethush-storerobbery:server:rob:register', RegisterId, true)
        end, function() -- Cancel
            OpeningRegister = false
            TriggerServerEvent('nethush-storerobbery:server:set:register:busy', RegisterId, false)
        end)
     else
        if IsAdvanced then
            if math.random(1,100) <= 19 then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos) 
                TriggerServerEvent('QBCore:Server:RemoveItem', 'advancedlockpick', 1)
              TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['advancedlockpick'], "remove")
              local StreetLabel = QBCore.Functions.GetStreetLabel()
              TriggerServerEvent("qb-police:server:send:alert:storerob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
            end
        else
            if math.random(1,100) <= 35 then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos) 
                TriggerServerEvent('QBCore:Server:RemoveItem', 'lockpick', 1)
              TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['lockpick'], "remove")
            end
        end
        TriggerEvent("swt_notifications:Infos","Failed..")
        local StreetLabel = QBCore.Functions.GetStreetLabel()
        TriggerServerEvent("qb-police:server:send:alert:storerob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
        TriggerServerEvent('nethush-storerobbery:server:set:register:busy', RegisterId, false)
     end
 end)
end

function CrackSafe(SafeId, IsAdvanced)
    if not IsWearingHandshoes() then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if math.random(1,100) < 40 then
        local StreetLabel = QBCore.Functions.GetStreetLabel()
        TriggerServerEvent("qb-police:server:send:alert:storerob", GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
    end
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerServerEvent('nethush-storerobbery:server:safe:busy', SafeId, true)
    exports['minigame-safecrack']:StartSafeCrack(8, function(OutCome)
        if OutCome == true then
            TriggerServerEvent("nethush-storerobbery:server:safe:reward", SafeId)
            TriggerServerEvent('nethush-storerobbery:server:safe:busy', SafeId, false)
            TriggerServerEvent("nethush-storerobbery:server:safe:robbed", SafeId, true)
            FreezeEntityPosition(PlayerPedId(), false)
            TakeAnimation()
        elseif OutCome == false and OutCome ~= 'Escaped' then
            if IsAdvanced then
                if math.random(1,100) <= 10 then
                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)                     
                    TriggerServerEvent('QBCore:Server:RemoveItem', 'advancedlockpick', 1)
                  TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['advancedlockpick'], "remove")
                end
            else
                if math.random(1,100) <= 20 then
                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)                   
                  TriggerServerEvent('QBCore:Server:RemoveItem', 'lockpick', 1)
                  TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['lockpick'], "remove")
                end
            end
            TriggerEvent("swt_notifications:Infos","Failed..")
            TriggerServerEvent('nethush-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            TriggerEvent("swt_notifications:Infos","Failed..")
            TriggerServerEvent('nethush-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end)
end

function LockPickRegisterAnim(time)
 time = time / 1000
 exports['nethush-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
 TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
 OpeningRegister = true
 Citizen.CreateThread(function()
     while OpeningRegister do
         TriggerServerEvent('qb-hud:Server:GainStress', 1)
         TriggerServerEvent('nethush-storerobbery:server:rob:register', CurrentRegister, false)  
         TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
         Citizen.Wait(2000)
         time = time - 2
         if time <= 0 then
             OpeningRegister = false
             StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
         end
     end
 end)
end

function TakeAnimation()
 exports['nethush-assets']:RequestAnimationDict("amb@prop_human_bum_bin@idle_b")
 TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
 Citizen.Wait(1500)
 TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
end

function IsWearingHandshoes()
  local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
  local model = GetEntityModel(PlayerPedId())
  local retval = true
  if model == GetHashKey("mp_m_freemode_01") then
      if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
          retval = false
      end
  else
      if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
          retval = false
      end
  end
  return retval
end

RegisterNetEvent('qb-storerobbery:client:robberyCall')
AddEventHandler('qb-storerobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" and onDuty then 
        local cameraId = 4
        if type == "safe" then
            cameraId = Config.Safes[key].camId
        else
            cameraId = Config.Registers[key].camId
        end
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "Shop robbery",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-video"></i>',
                    detail = cameraId,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })

        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 458)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("112: Shop robbery")
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