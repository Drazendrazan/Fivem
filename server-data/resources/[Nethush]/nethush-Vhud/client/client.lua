QBCore = nil
local VehicleSeat = nil
local PedCar = nil
local showing = false
local carspeed = 0
local firstShow = false
local canShow = true
local PlayerPed = PlayerPedId()
local street = 0
local lul1, lul2 = 0, 0
local current_zone = 0
local speedBuffer  = {}
local vc = nil
local hasKeys = false
local imageWidth = 100 -- leave this variable, related to pixel size of the directions
local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width
local minimap = nil
local seatbeltState = true


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition("minimap", "L", "B", 0.025, -0.05, 0.153, 0.24)
	SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135, 0.12, 0.093, 0.164)
	SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
    minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

function fecharHud()
	SendNUIMessage({
		showHud = false
	})
end

IsCar = function(veh)
	vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 13) or (vc >= 17 and vc <= 20)
end

function speedo()
	Citizen.CreateThread(function()
		PlayerPed = PlayerPedId()
		Citizen.Wait(50)
		while showing do
			speedBuffer[1] = GetEntitySpeed(PedCar) * 3.6
			if speedBuffer[1] ~= nil then
				carspeed = math.ceil(speedBuffer[1])
			end
			local fuel = exports['esx_fuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)))
			SetRadarBigmapEnabled(false, false)
			firstShow = false
			SendNUIMessage({
				showHud = true,
				engine = showeng,
				fuel = fuel,
				belt = seatbeltState,
				direction = math.floor(calcHeading(-GetEntityHeading(PlayerPed) % 360)),
				keys = hasKeys,
				mainstreet = current_zone,
				secondstreet = street,
				mph = carspeed,
			})
			Citizen.Wait(200)
		end
		fecharHud()
	end)
end

function mainThread()
	local lastFrameVehiclespeed = 0
	local lastFrameVehiclespeed2 = 0
	local thisFrameVehicleSpeed = 0
	local tick = 0
	local veloc = 0
	Citizen.CreateThread(function()
		while speedBuffer[1] == nil do
			Citizen.Wait(100)
		end
		while showing do
			if PedCar ~= 0 and IsCar(PedCar) then
				wasInPedCar = true
				if ((vc ~= 8) and (vc ~= 13))  then
					thisFrameVehicleSpeed = speedBuffer[1]

					--if seatbeltState then
					--	DisableControlAction(0, 75)
					end

				if (not seatbeltState and (lastFrameVehiclespeed > 150) and (thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.50))) then
						if (math.random(0, 10) <= 5) then
							SetEntityCoords(PlayerPed, GetOffsetFromEntityInWorldCoords(PedCar, 1.0, 0.0, 1.0))
							Citizen.Wait(1)
							SetPedToRagdoll(PlayerPed, 10000, 10000, 0, 0, 0, 0)
							veloc = GetEntityVelocity(PedCar)
							SetEntityVelocity(PlayerPed, veloc.x*4,veloc.y*4,veloc.z*4)
							seatbeltState = false

							if (GetEntityHealth(PlayerPed) > 0) then
								RequestAnimDict("dead")
								RequestAnimSet("move_m@injured")
								SetPedMovementClipset(PlayerPed, "move_m@injured", true)
								Wait(180000)
								ResetPedMovementClipset( PlayerPed, 0 )
							end
						--end
						lastFrameVehiclespeed = 0.0
						thisFrameVehicleSpeed = 0.0
						Citizen.Wait(1000)
					end

					if tick > 0 then 
						tick = tick - 1
						if tick == 1 then
							lastFrameVehiclespeed = carspeed
						end
					else

						lastFrameVehiclespeed2 = carspeed

						if lastFrameVehiclespeed2 > lastFrameVehiclespeed then
							lastFrameVehiclespeed = carspeed
						end
	
						if lastFrameVehiclespeed2 < lastFrameVehiclespeed then
							tick = 25
						end
	
					end
		
				--	if IsControlJustReleased(0, 305) then
					--	if BeltOn then
					--		seatbeltState = false
					--		--[[ TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'unbuckle', 0.3) ]]
					--	else
					--		seatbeltState = true
							--[[ TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'buckle', 0.3) ]]
					--	end
				--	end
				end

			elseif wasInPedCar then
				wasInPedCar = false
				seatbeltState = true
				cruiseOn = false
				speedBuffer[1] = 0.0
			end

			Citizen.Wait(10)
		end
	end)
end

Citizen.CreateThread(function()

	Citizen.Wait(10)
	local pos = nil
	local health = 1000
	while true do
		local fuel = exports['esx_fuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)))
		PedIn = IsPedInAnyVehicle(PlayerPedId())
		if PedIn then
			PedCar = GetVehiclePedIsIn(PlayerPedId(), false)
			VehicleSeat = GetPedInVehicleSeat(PedCar, -1)
			if canShow then
				if IsVehicleEngineOn(PedCar) and not IsPauseMenuActive() then
					if not showing then
						SetRadarZoom(1100)
						speedo()
						mainThread()
						showing = true
						DisplayRadar(true)
						SetRadarBigmapEnabled(false, false)
					end
					BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
					ScaleformMovieMethodAddParamInt(3)
					EndScaleformMovieMethod()
					pos = GetEntityCoords(PlayerPed)
		
					lul1, lul2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

					if lul1 ~= 0 then
						street = GetStreetNameFromHashKey(lul1)
						if lul2 ~= 0 then
							street = street .. " | " .. GetStreetNameFromHashKey(lul2)
						end
					end

					current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
	
					fuel = fuel

					health = GetVehicleEngineHealth(PedCar)

					if health <= 250 then
						showeng = 1
					elseif health <= 500 then
						showeng = 2
					else
						showeng = 3
					end

				else
					fecharHud()
					showing = false
					DisplayRadar(false)
				end

			else
				showing = false
				cruiseOn = false
				seatbeltState = true
				DisplayRadar(false)
			end

		else
			if not firstShow then
				DisplayRadar(false)
				fecharHud()
				firstShow = true
			end

			showing = false
			cruiseOn = false
			seatbeltState = true

		end
		Citizen.Wait(200)

	end

end)

function calcHeading(direction)
	if (direction < 90) then
		return lerp(north, east, direction / 90)
	elseif (direction < 180) then
		return lerp(east, south2, rangePercent(90, 180, direction))
	elseif (direction < 270) then
		return lerp(south, west, rangePercent(180, 270, direction))
	elseif (direction <= 360) then
		return lerp(west, north, rangePercent(270, 360, direction))
	end
end

function rangePercent(min, max, amt)
	return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
	return (1 - amt) * min + amt * max
end

RegisterNetEvent('carhud')
AddEventHandler('carhud',function(action)
	canShow = action
	if canShow then
		--exports['mythic_notify']:SendAlert('inform', 'HUD activated')
	else
		--exports['mythic_notify']:SendAlert('inform', 'HUD deactivated')
	end
end)

RegisterCommand("closeHud",function(source, args)
	fecharHud()
end, false)

Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 15.3, 0.9, 0.08, 0.0, 0.0)
end)

Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end)-- Prevents RAM LEAKS :)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltState = not seatbeltState
        SendNUIMessage({
            action = "belt",
            belt = seatbeltState,
        })
    else
        seatbeltState = toggle
        SendNUIMessage({
            action = "belt",
            belt = toggle,
        })
    end
end)