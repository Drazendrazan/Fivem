local LoggedIn = false
local QBCore = nil
local NearGarage = false
local IsMenuActive = false   

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
     Citizen.Wait(250)
     LoggedIn = true
 end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    if LoggedIn then
        NearGarage = false
        for k, v in pairs(Config.GarageLocations) do
          local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], true) 
          if Distance < v['Distance'] then
           NearGarage = true
           Config.CurrentGarageData = {['GarageNumber'] = k, ['GarageName'] = v['Name']}
          end
        end
        if not NearGarage then
          Citizen.Wait(1500)
          Config.CurrentGarageData = {}
        end
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('nethush-garages:client:check:owner')
AddEventHandler('nethush-garages:client:check:owner', function()
local Vehicle, VehDistance = QBCore.Functions.GetClosestVehicle()
local Plate = GetVehicleNumberPlateText(Vehicle)
  if VehDistance < 2.3 then
     QBCore.Functions.TriggerCallback("nethush-garage:server:is:vehicle:owner", function(IsOwner)
         if IsOwner then
           TriggerEvent('nethush-garages:client:set:vehicle:in:garage', Vehicle, Plate)
         else
          TriggerEvent('swt_notifications:Infos','This is not your vehicle')
         end
     end, Plate)
  else
    TriggerEvent('swt_notifications:Infos','No vehicles found?')
  end
end)

RegisterNetEvent('nethush-garages:client:set:vehicle:in:garage')
AddEventHandler('nethush-garages:client:set:vehicle:in:garage', function(Vehicle, Plate)
   local VehicleMeta = {Fuel = exports['qb-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
   local GarageData = Config.CurrentGarageData['GarageName']
    TaskLeaveAnyVehicle(PlayerPedId())
    Citizen.SetTimeout(1650, function()
      TriggerServerEvent('nethush-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
      QBCore.Functions.DeleteVehicle(Vehicle)
      TriggerEvent('swt_notifications:Infos','Vehicle parked in '..Config.CurrentGarageData['GarageName'])
    end)
end)

RegisterNetEvent('nethush-garages:client:set:vehicle:out:garage')
AddEventHandler('nethush-garages:client:set:vehicle:out:garage', function()
  OpenGarageMenu()
end)

RegisterNetEvent('nethush-garages:client:open:depot')
AddEventHandler('nethush-garages:client:open:depot', function()
  OpenDepotMenu()
end)

RegisterNetEvent('nethush-garages:client:spawn:vehicle')
AddEventHandler('nethush-garages:client:spawn:vehicle', function(Plate, VehicleName, Metadata)
  local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
  local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
  QBCore.Functions.SpawnVehicle(VehicleName, function(Vehicle)
    SetVehicleNumberPlateText(Vehicle, Plate)
    DoCarDamage(Vehicle, Metadata.Engine, Metadata.Body)
    Citizen.Wait(25)
     TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
    exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), Metadata.Fuel, false)
    TriggerEvent('swt_notifications:Infos','Vehicle parked.')
  end, CoordTable, true, false)
end)

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)

RegisterNUICallback('TakeOutVehicle', function(data)
  if IsNearGarage() then
    local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
    local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
    if data.State == 'in' then
      QBCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        QBCore.Functions.TriggerCallback('nethush-garage:server:get:vehicle:mods', function(Mods)
          QBCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
           TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
          exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          TriggerEvent('swt_notifications:Infos','Your vehicle has been parked in a parking spot', 'info')
          TriggerServerEvent('nethush-garages:server:set:garage:stater', data.Plate, 'out')
        end, data.Plate)
      end, CoordTable, true, false)
    else
        TriggerEvent("swt_notifications:Infos","Vehicle is in the impound.", "info", 3500)
    end
  elseif IsNearDepot() then
    QBCore.Functions.TriggerCallback('nethush-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = 421.0100, y = -1639.1508, z = 28.5563, a = 91.2197}
        QBCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        QBCore.Functions.TriggerCallback('nethush-garage:server:get:vehicle:mods', function(Mods)
        QBCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
           TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
          exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          TriggerEvent('swt_notifications:Infos','Retrieved vehicle out of impound')
          TriggerServerEvent('nethush-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('nethush-garages:server:set:garage:stater', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif IsNearBoatDepot() then
    QBCore.Functions.TriggerCallback('nethush-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = -799.87, y = -1488.97, z = 0.6260614, a = 299.67}
        QBCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        QBCore.Functions.TriggerCallback('nethush-garage:server:get:vehicle:mods', function(Mods)
        QBCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
           TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
          exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          TriggerEvent('swt_notifications:Infos','Retrieved vehicle out of impound')
          TriggerServerEvent('nethush-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('nethush-garages:server:set:garage:stater', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif exports['qb-housing']:NearHouseGarage() then
    if data.State == 'in' then
      local VehicleSpawn = exports['qb-housing']:GetGarageCoords()
      local CoordTable = {x = VehicleSpawn['X'], y = VehicleSpawn['Y'], z = VehicleSpawn['Z'], a = VehicleSpawn['H']}
      QBCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        QBCore.Functions.TriggerCallback('nethush-garage:server:get:vehicle:mods', function(Mods)
             QBCore.Functions.SetVehicleProperties(Vehicle, Mods)
             SetVehicleNumberPlateText(Vehicle, data.Plate)
             Citizen.Wait(25)
             DoCarDamage(Vehicle, data.Engine, data.Body)
             Citizen.Wait(25)
             TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
              TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(Vehicle))
             exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
             TriggerEvent('swt_notifications:Infos','Retrieved vehicle out of impound')
             TriggerServerEvent('nethush-garages:server:set:garage:stater', data.Plate, 'out')
             CloseMenuFull()
           end, data.Plate)
        end, CoordTable, true, false)
      else
        TriggerEvent("swt_notifications:Infos","Your vehicle is in the impound.", "info", 3500)
    end
  end
end)

-- // Functions \\ --

function DoCarDamage(Vehicle, EngineHealth, BodyHealth)
	SmashWindows = false
	damageOutside = false
	damageOutside2 = false 
	local engine = EngineHealth + 0.0
	local body = BodyHealth + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		SmashWindows = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, engine)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(Vehicle, 985.0)
  end
end

function IsNearGarage()
  return NearGarage
end

function IsNearDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local Distance = GetDistanceBetweenCoords(PlayerCoords, 409.4566, -1648.4667, 28.5550, true) 
  if Distance < 30.0 then
    return true
  end
end

function IsNearBoatDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local DistanceBoat = GetDistanceBetweenCoords(PlayerCoords, -799.87, -1488.97, 0.6260614, true) 
  if DistanceBoat < 10.0 then
    return true
  end
end


function OpenGarageMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  QBCore.Functions.TriggerCallback("nethush-garage:server:GetUserVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
             local Vehicle = {}
             local MetaData = json.decode(v.metadata)
             Vehicle = {['Name'] = QBCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage,['State'] = v.stater, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
             table.insert(VehicleTable, Vehicle) 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        TriggerEvent("swt_notifications:Infos","You have no vehicles or boats in this garage")
      end
  end, Config.CurrentGarageData['GarageName'])
end

function OpenDepotMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  QBCore.Functions.TriggerCallback("nethush-garage:server:GetDepotVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              if v.stater == 'out' then
                local Vehicle = {}
                local MetaData = json.decode(v.metadata)
                Vehicle = {['Name'] = QBCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.stater, ['Price'] = v.depotprice, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
                table.insert(VehicleTable, Vehicle)
              end 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenDepot", depotvehicles = VehicleTable})
      else
        TriggerEvent("swt_notifications:Infos","No impounded vehicles")
      end
  end)
end

function OpenHouseGarage(HouseId)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  QBCore.Functions.TriggerCallback("nethush-garage:server:GetHouseVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = QBCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.stater, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        TriggerEvent("swt_notifications:Infos","You have no vehicles or boats in this garage")
      end
  end, HouseId)
end

function SetVehicleInHouseGarage(HouseId)
  local Vehicle = GetVehiclePedIsIn(PlayerPedId())
  local Plate = GetVehicleNumberPlateText(Vehicle)
  local VehicleMeta = {Fuel = exports['qb-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
  local GarageData = HouseId
  TaskLeaveAnyVehicle(PlayerPedId())
  Citizen.SetTimeout(1650, function()
    TriggerServerEvent('nethush-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
    QBCore.Functions.DeleteVehicle(Vehicle)
    TriggerEvent('swt_notifications:Infos','Vehicles parked in '..HouseId)
  end)
end