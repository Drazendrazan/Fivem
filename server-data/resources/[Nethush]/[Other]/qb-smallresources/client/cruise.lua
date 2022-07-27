local cruiseOn = false
local Speed = 0.0
local cruiseSpeed = 0.0
local lastVehicle = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1)))

            if IsControlJustReleased(0, Keys["B"]) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then 
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    cruiseSpeed = Speed
                    if cruiseOn then
                       -- TriggerEvent("swt_notifications:Infos","Limiter switched off!")
                        TriggerEvent("swt_notifications:Negative","Car","Limiter switched off!","top-right",2000,true)
                    else
                       -- TriggerEvent("swt_notifications:Infos","Limiter set to "..tostring(math.floor(cruiseSpeed * 3.6)).."km/h")
                        TriggerEvent("swt_notifications:Negative","Car","Limiter set to "..tostring(math.floor(cruiseSpeed * 3.6)).."km/h","top-right",2000,true)
                    end
                    TriggerEvent("seatbelt:client:ToggleCruise")
                end
            end
        elseif lastVehicle ~= nil then
            local maxSpeed = GetVehicleHandlingFloat(lastVehicle,"CHandlingData","fInitialDriveMaxFlatVel")
            SetEntityMaxSpeed(lastVehicle, maxSpeed)
            lastVehicle = nil
            Citizen.Wait(1500)
        end
    end
end)

RegisterNetEvent("seatbelt:client:ToggleCruise")
AddEventHandler("seatbelt:client:ToggleCruise", function()
    cruiseOn = not cruiseOn
    local maxSpeed = cruiseOn and cruiseSpeed or GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false),"CHandlingData","fInitialDriveMaxFlatVel")
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), maxSpeed)
    lastVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
end)