local IsBusy = false
local LoggedIn = false
QBCore = nil

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(250)
        QBCore.Functions.TriggerCallback("qb-fuel:server:get:fuel:config", function(config)
            Config = config
        end)
        LoggedIn = true
    end)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('qb-fuel:client:register:vehicle:fuel')
AddEventHandler('qb-fuel:client:register:vehicle:fuel', function(Plate, Vehicle, Amount)
 Config.VehicleFuel[Plate] = Amount
end)

RegisterNetEvent('qb-fuel:client:update:vehicle:fuel')
AddEventHandler('qb-fuel:client:update:vehicle:fuel', function(Plate, Vehicle, Amount)
 Config.VehicleFuel[Plate] = Amount
end)

-- // Functions \\ --

function GetFuelLevel(Plate)
    if Config.VehicleFuel[Plate] ~= nil then
        return Config.VehicleFuel[Plate]
    else
        return 0
    end
end

function SetFuelLevel(Vehicle, Plate, Amount, Spawned)
 if Amount < 0 then 
  Amount = 0 
 end
 if Spawned then
    if Amount < 100 or GetFuelLevel(Plate) < 100 then
        Amount = 100
    end
 end
 SetVehicleFuelLevel(Vehicle, Amount + 0.0)
 TriggerServerEvent('qb-fuel:server:update:fuel', Plate, Vehicle, math.floor(Amount))
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
 ClearDrawOrigin()
end

function Round(num, numDecimalPlaces)
 local mult = 10^(numDecimalPlaces or 0)
 return math.floor(num * mult + 0.5) / mult
end