local isUiOpen = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local harnessOn = false
local harnessHp = 20
local handbrake = 0
local sleep = 0
local harnessData = {}


IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end
 
 
Citizen.CreateThread(function()
  print("TripleCaution")
  while true do
  Citizen.Wait(0)
  if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
    beltOn = false
    TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
end
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped)
    
    if car ~= 0 and (wasInCar or IsCar(car)) then
      wasInCar = true
             if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({seatbelt_blink = true})
                isUiOpen = true 			
            end

      speedBuffer[2] = speedBuffer[1]
      speedBuffer[1] = GetEntitySpeed(car)
      
      if speedBuffer[2] ~= nil 
         and not beltOn
         and GetEntitySpeedVector(car, true).y > 1.0  
         and speedBuffer[1] > 19.25 
         and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
         
        local co = GetEntityCoords(ped)
        local fw = Fwv(ped)
        SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
        SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
        Citizen.Wait(1)
        SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
      end
        
      velBuffer[2] = velBuffer[1]
      velBuffer[1] = GetEntityVelocity(car)
        
      if IsControlJustReleased(0, 183) and GetLastInputMethod(0) then
        beltOn = not beltOn 
        if beltOn then 
          TriggerEvent("seatbelt:client:ToggleSeatbelt",true)
		  SendNUIMessage({seatbelt_blink = false})
		  isUiOpen = true 
      TriggerServerEvent("InteractSound_SV:PlayOnSource", "carbuckle", 0.25)

		else 
      TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
		  SendNUIMessage({seatbelt_blink = true})
      TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
		  isUiOpen = true  
		end
      end
      
    elseif wasInCar then
      wasInCar = false
      beltOn = false
      speedBuffer[1], speedBuffer[2] = 0.0, 0.0
             if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({seatbelt_blink = false})
                isUiOpen = false 
            end
    end
    
  end
end)


function ResetHandBrake()
    if handbrake > 0 then
        handbrake = handbrake - 1
    end
end

-- Export

function HasHarness()
    return harnessOn
end

-- Main Thread

CreateThread(function()
    while true do
        sleep = 1000
        if IsPedInAnyVehicle(PlayerPedId()) then
            sleep = 10
            if beltOn or harnessOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
        else
            beltOn = false
            harnessOn = false
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local PlayerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(PlayerPed, false)
        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
            SetPedHelmet(PlayerPed, false)
            lastVehicle = GetVehiclePedIsIn(PlayerPed, false)
            if GetVehicleEngineHealth(currentVehicle) < 0.0 then
                SetVehicleEngineHealth(currentVehicle,0.0)
            end
            ThisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
            CurrentBodyHealth = GetVehicleBodyHealth(currentVehicle)
            if CurrentBodyHealth == 1000 and FrameBodyChange ~= 0 then
                FrameBodyChange = 0
            end
            if FrameBodyChange ~= 0 then
                if LastFrameVehicleSpeed > math.random(175, 185) and ThisFrameVehicleSpeed < (LastFrameVehicleSpeed * 0.75) and not IsEjected then
                    if FrameBodyChange > 18.0 then
                        if not beltOn and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                EjectFromVehicle(vels)
                            end
                        elseif (beltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 150 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 150 then
                                    EjectFromVehicle(vels)                   
                                end
                            end
                        end
                    else
                        if not beltOn and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                EjectFromVehicle(vels)                      
                            end
                        elseif (beltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 120 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 200 then
                                    EjectFromVehicle(vels)                   
                                end
                            end
                        end
                    end
                    IsEjected = true
                    Citizen.Wait(15)
                    DoWheelDamage(currentVehicle)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                end
                if CurrentBodyHealth < 350.0 and not IsEjected then
                    IsEjected = true
                    Citizen.Wait(15)
                    DoWheelDamage(currentVehicle)
                    SetVehicleBodyHealth(targetVehicle, 945.0)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
            end
            if LastFrameVehicleSpeed < 100 then
                Wait(100)
                Ticks = 0
            end
            FrameBodyChange = NewBodyHealth - CurrentBodyHealth
            if Ticks > 0 then 
                Ticks = Ticks - 1
                if Ticks == 1 then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
            else
                if IsEjected then
                    IsEjected = false
                    FrameBodyChange = 0
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                SecondLastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                if SecondLastFrameVehicleSpeed > LastFrameVehicleSpeed then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                if SecondLastFrameVehicleSpeed < LastFrameVehicleSpeed then
                    Ticks = 25
                end
            end
            vels = GetEntityVelocity(currentVehicle)
            if Ticks < 0 then 
                Ticks = 0
            end     
            NewBodyHealth = GetVehicleBodyHealth(currentVehicle)
            veloc = GetEntityVelocity(currentVehicle)
        else
            if lastVehicle ~= nil then
                SetPedHelmet(PlayerPed, true)
                Citizen.Wait(200)
                NewBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not IsEjected and NewBodyHealth < CurrentBodyHealth then
                    IsEjected = true
                    SetVehicleEngineHealth(lastVehicle, 0)
                    SetVehicleEngineOn(lastVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
                lastVehicle = nil
            end
            SecondLastFrameVehicleSpeed = 0
            LastFrameVehicleSpeed = 0
            NewBodyHealth = 0
            CurrentBodyHealth = 0
            FrameBodyChange = 0
            Citizen.Wait(2000)
        end
    end
end)

-- // Functions \\ --

function EjectFromVehicle(VehicleVelocity)
 local Vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
 local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, 1.0)
 local EjectSpeed = math.ceil(GetEntitySpeed(PlayerPedId()) * 8)
 SetEntityCoords(PlayerPedId(), Coords)
 Citizen.Wait(1)
 SetPedToRagdoll(PlayerPedId(), 5511, 5511, 0, 0, 0, 0)
 SetEntityVelocity(PlayerPedId(), VehicleVelocity.x*4, VehicleVelocity.y*4, VehicleVelocity.z*4)
 SetEntityHealth( PlayerPedId(), (GetEntityHealth(PlayerPedId()) - EjectSpeed))
 Citizen.SetTimeout(2500, function()
    IsEjected = false
 end)
end

function DoWheelDamage(Vehicle)
 local wheels = {0,1,4,5}
 for i=1, math.random(4) do
     local wheel = math.random(#wheels)
     SetVehicleTyreBurst(Vehicle, wheels[wheel], true, 1000)
     table.remove(wheels, wheel)
 end
end


------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn then
      if GetVehicleClass(plyVeh) == 1 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 2 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)


Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 5 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 6 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 7 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)


Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 9 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)



Citizen.CreateThread(function()
  while true do
      Citizen.Wait(10000)
      local ped = GetPlayerPed(-1)
      local invehicle = IsPedInAnyVehicle(ped, true)
      local plyPed = PlayerPedId()
      local plyVeh = GetVehiclePedIsIn(plyPed, false)
      local veh = GetVehiclePedIsIn(ped)

  local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))

  if not beltOn and invehicle and EngineOn and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)then
      if GetVehicleClass(plyVeh) == 18 then 
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.1, 'tesladbelt', 0.25)
          TriggerEvent("swt_notifications:Warning","SLMC System","Please Wear SeatBelt...","top-right",3000,true)

   Citizen.Wait(10000)
   end
  end
end
end)