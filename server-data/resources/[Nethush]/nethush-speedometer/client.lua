local nmode = 1
local mode = "eco_pro"
local speed = 0
local health = 0
local oil = 100
local gas = 100
local seatbelt = false

RegisterNetEvent("speedometer:left")
AddEventHandler("speedometer:left", function(bool)
	print(bool)
	SendNUIMessage({left_blink = bool})
end)

RegisterNetEvent("speedometer:right")
AddEventHandler("speedometer:right", function(bool)
	print(bool)
	SendNUIMessage({right_blink = bool})
end)

RegisterNetEvent("speedometer:both")
AddEventHandler("speedometer:both", function(bool)
	print(bool)
	if bool then
		SendNUIMessage({both_blink = true})
	else
		SendNUIMessage({both_blink = false})
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)

		if IsPedGettingIntoAVehicle(ped) then
			SendNUIMessage({displayhud = false})
		end
		if IsPedInAnyVehicle(ped) and not IsPedInAnyPlane(ped) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle then
				if not Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle) then
					SendNUIMessage({displayhud = true, mode = "none", speed = 0, gas = 100, health = 100, oil = 100})
				else
					health = GetVehicleBodyHealth(vehicle)-900
					gas = GetVehicleFuelLevel(vehicle)
					speed = math.ceil(GetEntitySpeed(vehicle) * 3.6)
					oil = 10*GetVehicleOilLevel(vehicle)
					

					SendNUIMessage({displayhud = true, mode = mode, speed = speed, gas = gas, health = health, oil = oil})
					if IsControlJustPressed(0, 246) then
						nmode = nmode + 1
						if nmode == 4 then
							nmode = 1
						end
					end
				end
			else
				SendNUIMessage({displayhud = false})
				Citizen.Wait(1000)
			end
		else
			mode = "normal"
			nmode = 1
			seatbelt = false
			SendNUIMessage({displayhud = false})
			Citizen.Wait(100)
		end
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	
	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)

		if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			
			if nmode == 1 then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, (maxSpeed - maxSpeed*0.80))
				mode = "eco_pro"
			elseif nmode == 2 then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed - maxSpeed*0.75)
				mode = "normal"
			elseif nmode == 3 then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, (maxSpeed))
				mode = "sport"
			end
		end
	end
end)
