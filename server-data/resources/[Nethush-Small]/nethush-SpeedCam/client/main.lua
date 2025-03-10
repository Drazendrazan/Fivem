-- BELOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE! --

local useBilling = false -- OPTIONS: (true/false)
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = true -- OPTIONS: (true/false)
local useBlips = true -- OPTIONS: (true/false)
local alertPolice = true -- OPTIONS: (true/false)
local alertSpeed = 200 -- OPTIONS: (1-5000 KMH)

-- ABOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE!  --







local Keys = {
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
local PlayerData              = {}

QBCore = nil
local hasBeenCaught = false

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
	
	while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = QBCore.Functions.GetPlayerData()
end)

--onload player
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
    
end)
--setjob
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- BLIP FOR SPEEDCAMERA (START)

local blips = {
	-- 60KM/H ZONES
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 171.37, y = -826.69, z = 31.17}, -- 80KM/H ZONE
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 309.9, y = -458.22, z = 43.37},
	
	-- 80KM/H ZONES
	{title="Speedcamera (100KM/H)", colour=1, id=1, x = -744.2207, y = -655.3946, z =30.3332}, -- 100KM/H ZONE
	{title="Speedcamera (100KM/H)", colour=1, id=1, x = 146.13, y = -1405.18, z = 29.18}, -- 100KM/H ZONE
	
	-- 120KM/H ZONES
	{title="Speedcamera (150KM/H)", colour=1, id=1, x = -2660.2109, y = 2618.7427, z = 16.6770}, -- 150KM/H ZONE
	{title="Speedcamera (150KM/H)", colour=1, id=1, x = 2442.2006, y = -134.6004, z = 88.7765}, -- 150KM/H ZONE
	{title="Speedcamera (150KM/H)", colour=1, id=1, x = 2871.7951, y = 3540.5795, z = 53.0930} -- 150KM/H ZONE
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

-- BLIP FOR SPEEDCAMERA (END)

local Speedcamera60Zone = {
{x = 309.9, y = -458.22, z = 43.37},
{x = 171.37, y = -826.69, z = 31.17},
}

local Speedcamera80Zone = {
    {x = -744.2207, y = -655.3946, z = 30.3332},
    {x = 146.13,y = -1405.18,z = 29.18},
}

local Speedcamera120Zone = {
    {x = -2660.2109, y = 2618.7427, z = 16.6770},
    {x = 2442.2006,y = -134.6004,z = 88.7765},
    {x = 2871.7951,y = 3540.5795,z = 53.0930},
}

-- 60 ZONE (START)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera60Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera60Zone[k].x, Speedcamera60Zone[k].y, Speedcamera60Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 80.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
											--TriggerServerEvent('qb-phonenew:startCall', 'police', 'High Speed'�, oltre i ' .. alertSpeed.. ' KMH', PlayerCoords, {
			                                --PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("swt_notifications:Infos","you have been fined for speed exceeding maximum limit exceeded: 80KM")
									
									if useBilling == true then
										--TriggerServerEvent('esx_bismacklling:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Speedcamera (80KM/H)', 200) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill60Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

-- 60 ZONE (END)

-- 80 ZONE (START)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera80Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera80Zone[k].x, Speedcamera80Zone[k].y, Speedcamera80Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 100.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
											--TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'High speed'�, oltre i ' .. alertSpeed.. ' KMH', --PlayerCoords, {

											--	PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
											--})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("swt_notifications:Infos","you have been fined for speed exceeding maximum limit exceeded: 100KM.")
									
									if useBilling == true then
										--TriggerServerEvent('esx_bismacklling:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Speedcamera (80KM/H)', 400) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill80Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

-- 80 ZONE (END)

-- 120 ZONE (START)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera120Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera120Zone[k].x, Speedcamera120Zone[k].y, Speedcamera120Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 150.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
											--TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'High Speed'�, oltre i ' .. alertSpeed.. ' KMH', PlayerCoords, {

											--	PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
											--})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)
								
									TriggerEvent("swt_notifications:Infos","you have been fined for speed exceeding maximum limit exceeded: 150KM.")
									
									if useBilling == true then
										--TriggerServerEvent('esx_bismacklling:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Speedcamera (120KM/H)', 600) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill120Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

-- 120 ZONE (END)

RegisterNetEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
end)