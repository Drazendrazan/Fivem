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
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 0
--QBCore = nil
QBCore = nil

local LastCar
local requiredItemsShowed = false

-- function DisplayHelpText(str)
-- 	SetTextComponentFormat("STRING")
-- 	AddTextComponentString(str)
-- 	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
-- end
-- Citizen.CreateThread(function()
-- 	while QBCore == nil do
-- 		TriggerEvent('QBCore:getSharedObject', function(obj) QBCore = obj end)
-- 		Citizen.Wait(0)
-- 	end
-- end)

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('qb-methcar:stop')
AddEventHandler('qb-methcar:stop', function()
	started = false
	--DisplayHelpText("~r~Production stopped...")
	TriggerEvent('swt_notifications:Infos','Production stopped...')
	FreezeEntityPosition(LastCar, false)
end)
RegisterNetEvent('qb-methcar:stopfreeze')
AddEventHandler('qb-methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('qb-methcar:notify')
AddEventHandler('qb-methcar:notify', function(message)
	--QBCore.ShowNotification(message)
	TriggerEvent("swt_notifications:Infos","Message")
end)

RegisterNetEvent('qb-methcar:startprod')
AddEventHandler('qb-methcar:startprod', function()
	--DisplayHelpText("~g~Starting production")
	TriggerEvent('swt_notifications:Infos','Starting production...')
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('Started Meth production')
	--QBCore.ShowNotification("~r~Meth production has started")	
	TriggerEvent('swt_notifications:Infos','Meth Production has started')
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('qb-methcar:blowup')
AddEventHandler('qb-methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)	
end)


RegisterNetEvent('qb-methcar:smoke')
AddEventHandler('qb-methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end
end)

RegisterNetEvent('qb-methcar:drugged')
AddEventHandler('qb-methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								--DisplayHelpText("Press ~INPUT_THROW_GRENADE~ to start making drugs")
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['Y']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('qb-methcar:start')	
									progress = 0
									pause = false
									selection = 0
									quality = 0
								else
								  --DisplayHelpText('~r~The car is already occupied')
									TriggerEvent('swt_notifications:Infos','The car is already occupied..')
								end
							else
								--QBCore.ShowNotification('~r~You are too close to the city, head further up north to begin meth production')
								TriggerEvent('swt_notifications:Infos','The are is not safe, Head further North to begin meth production')
							end
						end
					end
			end	
		else
				if started then
					started = false
					displayed = false
					TriggerEvent('qb-methcar:stop')
					print('Stopped making drugs')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					--QBCore.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
					TriggerEvent('swt_notifications:Infos','Meth production: ' ..progress.. '%')
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~The propane pipe is leaking, what do you do?')	
						TriggerEvent('swt_notifications:Infos','The propane pipe is leaking, What do you do?')
						--QBCore.ShowNotification('~o~1. Fix using tape')
						TriggerEvent('swt_notifications:Infos','N7. Fix using tape')
						--QBCore.ShowNotification('~o~2. Leave it be ')
						TriggerEvent('swt_notifications:Infos','N8. Leave it be')
						--QBCore.ShowNotification('~o~3. Replace it')
						TriggerEvent('swt_notifications:Infos','N9. Replace it')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do?')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~The tape kinda stopped the leak')
						TriggerEvent('swt_notifications:Infos','The tape kinda stopped the leak?')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~The propane tank blew up, you messed up...')
						TriggerEvent('swt_notifications:Infos','The propane tank blew up, you messed up...')
						TriggerServerEvent('qb-methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Stopped making drugs')
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Good job, the pipe wasnt in a good condition')
						TriggerEvent('swt_notifications:Infos','Good job, the pipe wasn\'t in a good condition')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You spilled a bottle of acetone on the ground, what do you do?')
						TriggerEvent('swt_notifications:Infos','You spilled a bottle of acetone on the ground, what do you do?')	
						--QBCore.ShowNotification('~o~1. Open the windows to get rid of the smell')
						TriggerEvent('swt_notifications:Infos','N7. Open the windows to get rid of the smell')
						--QBCore.ShowNotification('~o~2. Leave it be')
						TriggerEvent('swt_notifications:Infos','N8. Leave it be')
						--QBCore.ShowNotification('~o~3. Put on a mask with airfilter')
						TriggerEvent('swt_notifications:Infos','N9. Put on a mask with airfilter')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do..')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~You opened the windows to get rid of the smell')
						TriggerEvent('swt_notifications:Infos','You opened the windows to get rid of the smell')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~You got high from inhaling acetone too much')
						TriggerEvent('swt_notifications:Infos','You got high from inhaling acetone too much')
						pause = false
						TriggerEvent('qb-methcar:drugged')
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Thats an easy way to fix the issue.. I guess')
						TriggerEvent('swt_notifications:Infos','Thats an easy way to fix the issue.. I guess')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~Meth becomes solid too fast, what do you do? ')
						TriggerEvent('swt_notifications:Infos','Meth becomes solid too fast, what do you do?')	
						--QBCore.ShowNotification('~o~1. Raise the pressure')
						TriggerEvent('swt_notifications:Infos','N7. Raise the pressure')
						--QBCore.ShowNotification('~o~2. Raise the temperature')
						TriggerEvent('swt_notifications:Infos','N8. Raise the temperature')
						--QBCore.ShowNotification('~o~3. Lower the pressure')
						TriggerEvent('swt_notifications:Infos','N9. Lower the pressure')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~You raised the pressure and the propane started escaping, you lowered it and its okay for now')
						TriggerEvent('swt_notifications:Infos','You raised the pressure and the propane started escaping, you lowered it and its okay for now')
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~Raising the temperature helped...')
						TriggerEvent('swt_notifications:Infos','Raising the temperature helped...')
						quality = quality + 5
						pause = false
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Lowering the pressure just made it worse...')
						TriggerEvent('swt_notifications:Infos','Lowering the pressure just made it worse...')
						pause = false
						quality = quality -4
					end
				end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You accidentally pour too much acetone, what do you do?')	
                        TriggerEvent('swt_notifications:Infos','You accidentally pour too much acetone, what do you do?')
						--QBCore.ShowNotification('~o~1. Do nothing')
						TriggerEvent('swt_notifications:Infos','N7. Do nothing')
						--QBCore.ShowNotification('~o~2. Try to sucking it out using syringe')
						TriggerEvent('swt_notifications:Infos','N8. Try to sucking it out using syringe')
						--QBCore.ShowNotification('~o~3. Add more lithium to balance it out')
						TriggerEvent('swt_notifications:Infos','N9. Add more lithium to balance it out')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~The meth is not smelling like acetone a lot')
						TriggerEvent('swt_notifications:Infos','The meth is not smelling like acetone a lot')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~It kind of worked but its still too much')
						TriggerEvent('swt_notifications:Infos','It kind of worked but its still too much')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~You successfully balanced both chemicals out and its good again')
						TriggerEvent('swt_notifications:Infos','You successfully balanced both chemicals out and its good again')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You found some water coloring, what do you do?')	
						TriggerEvent('swt_notifications:Infos','You found some water coloring, what do you do?')
						--QBCore.ShowNotification('~o~1. Add it in')
						TriggerEvent('swt_notifications:Infos','N7. Add it in')
					  --	QBCore.ShowNotification('~o~2. Put it away')
						TriggerEvent('swt_notifications:Infos','N8. Put it away')
						--QBCore.ShowNotification('~o~3. Drink it')
						TriggerEvent('swt_notifications:Infos','N9. Drink it')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~Good idea, people like colors')
						TriggerEvent('swt_notifications:Infos','Good idea, people like colors')
						quality = quality + 4
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~Yeah it might destroy the taste of meth')
						TriggerEvent('swt_notifications:Infos','Yeah it might destroy the taste of meth')
						pause = false
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~You are a bit weird and feel dizzy but its all good')
						TriggerEvent('swt_notifications:Infos','You are a bit weird and feel dizzy but its all good')
						pause = false
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~The filter is clogged, what do you do?')
						TriggerEvent('swt_notifications:Infos','The filter is clogged, what do you do?')	
						--QBCore.ShowNotification('~o~1. Clean it using compressed air')
						TriggerEvent('swt_notifications:Infos','N7. Clean it using compressed air')
						--QBCore.ShowNotification('~o~2. Replace the filter')
						TriggerEvent('swt_notifications:Infos','N8. Replace the filter')
						--QBCore.ShowNotification('~o~3. Clean it using a tooth brush')
						TriggerEvent('swt_notifications:Infos','N9. Clean it using a tooth brush')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~Compressed air sprayed the liquid meth all over you')
						TriggerEvent('swt_notifications:Infos','Compressed air sprayed the liquid meth all over you')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~Replacing it was probably the best option')
						TriggerEvent('swt_notifications:Infos','Replacing it was probably the best option')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~This worked quite well but its still kinda dirty')
						TriggerEvent('swt_notifications:Infos','This worked quite well but its still kinda dirty')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You spilled a bottle of acetone on the ground, what do you do?')	
						TriggerEvent('swt_notifications:Infos','You spilled a bottle of acetone on the ground, what do you do?')
						--QBCore.ShowNotification('~o~1. Open the windows to get rid of the smell')
						TriggerEvent('swt_notifications:Infos','N7. Open the windows to get rid of the smell')
						--QBCore.ShowNotification('~o~2. Leave it be')
						TriggerEvent('swt_notifications:Infos','N8. Leave it be')
						--QBCore.ShowNotification('~o~3. Put on a mask with airfilter')
						TriggerEvent('swt_notifications:Infos','NN9. Put on a mask with airfilter')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~You opened the windows to get rid of the smell')
						TriggerEvent('swt_notifications:Infos','You opened the windows to get rid of the smell')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~You got high from inhaling acetone too much')
						TriggerEvent('swt_notifications:Infos','You got high from inhaling acetone too much')
						pause = false
						TriggerEvent('qb-methcar:drugged')
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Thats an easy way to fix the issue.. I guess')
						TriggerEvent('swt_notifications:Infos','Thats an easy way to fix the issue.. I guess')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~The propane pipe is leaking, what do you do?')	
						TriggerEvent('swt_notifications:Infos','The propane pipe is leaking, What do you do?')
						--QBCore.ShowNotification('~o~1. Fix using tape')
						TriggerEvent('swt_notifications:Infos','N7. Fix using tape')
						--QBCore.ShowNotification('~o~2. Leave it be ')
						TriggerEvent('swt_notifications:Infos','N8. Leave it be')
						--QBCore.ShowNotification('~o~3. Replace it')
						TriggerEvent('swt_notifications:Infos','N9. Replace it')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~The tape kinda stopped the leak')
						TriggerEvent('swt_notifications:Infos','The tape kinda stopped the leak')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~The propane tank blew up, you messed up...')
						TriggerEvent('swt_notifications:Infos','The propane tank blew up, you messed up...')
						TriggerServerEvent('qb-methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Stopped making drugs')
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Good job, the pipe wasnt in a good condition')
						TriggerEvent('swt_notifications:Infos','Good job, the pipe wasnt in a good condition')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~The filter is clogged, what do you do?')
						TriggerEvent('swt_notifications:Infos','The filter is clogged, what do you do?')	
						--QBCore.ShowNotification('~o~1. Clean it using compressed air')
						TriggerEvent('swt_notifications:Infos','N7. Clean it using compressed air')
						--QBCore.ShowNotification('~o~2. Replace the filter')
						TriggerEvent('swt_notifications:Infos','N8. Replace the filter')
						--QBCore.ShowNotification('~o~3. Clean it using a tooth brush')
						TriggerEvent('swt_notifications:Infos','N9. Clean it using a tooth brush')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~Compressed air sprayed the liquid meth all over you')
						TriggerEvent('swt_notifications:Infos','Compressed air sprayed the liquid meth all over you')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~Replacing it was probably the best option')
						TriggerEvent('swt_notifications:Infos','Replacing it was probably the best option')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~This worked quite well but its still kinda dirty')
						TriggerEvent('swt_notifications:Infos','This worked quite well but its still kinda dirty')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You accidentally pour too much acetone, what do you do?')	
						TriggerEvent('swt_notifications:Infos','You accidentally pour too much acetone, what do you do?')
						--QBCore.ShowNotification('~o~1. Do nothing')
						TriggerEvent('swt_notifications:Infos','N7. Do nothing')
						--QBCore.ShowNotification('~o~2. Try to sucking it out using syringe')
						TriggerEvent('swt_notifications:Infos','N8. Try to sucking it out using syringe')
						--QBCore.ShowNotification('~o~3. Add more lithium to balance it out')
						TriggerEvent('swt_notifications:Infos','N9. Add more lithium to balance it out')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~The meth is not smelling like acetone a lot')
						TriggerEvent('swt_notifications:Infos','The meth is not smelling like acetone a lot')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~It kind of worked but its still too much')
						TriggerEvent('swt_notifications:Infos','It kind of worked but its still too much')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~You successfully balanced both chemicals out and its good again')
						TriggerEvent('swt_notifications:Infos','You successfully balanced both chemicals out and its good again')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~You need to take a shit, what do you do?')	
						TriggerEvent('swt_notifications:Infos','You need to take a shit, what do you do?')
						--QBCore.ShowNotification('~o~1. Try to hold it')
						TriggerEvent('swt_notifications:Infos','N7. Try to hold it')
						--QBCore.ShowNotification('~o~2. Go outside and take a shit')
						TriggerEvent('swt_notifications:Infos','N8. Go outside and take a shit')
						--QBCore.ShowNotification('~o~3. Shit inside')
						TriggerEvent('swt_notifications:Infos','N9. Shit inside')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~Good job, you need to work first, shit later')
						TriggerEvent('swt_notifications:Infos','Good job, you need to work first, shit later')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~While you were outside the glass fell off the table and spilled all over the floor...')
						TriggerEvent('swt_notifications:Infos','While you were outside the glass fell off the table and spilled all over the floor...')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~The air smells like shit now, the meth smells like shit now')
						TriggerEvent('swt_notifications:Infos','The air smells like shit now, the meth smells like shit now')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						--QBCore.ShowNotification('~o~Do you add some glass pieces to the meth so it looks like you have more of it?')
						TriggerEvent('swt_notifications:Infos','Do you add some glass pieces to the meth so it looks like you have more of it?')	
						--QBCore.ShowNotification('~o~1. Yes!')
						TriggerEvent('swt_notifications:Infos','N7. Yes!')
						--QBCore.ShowNotification('~o~2. No')
						TriggerEvent('swt_notifications:Infos','N8. No')
						--QBCore.ShowNotification('~o~3. What if I add meth to glass instead?')
						TriggerEvent('swt_notifications:Infos','N9. What if I add meth to glass instead')
						--QBCore.ShowNotification('~c~Press the number of the option you want to do')
						TriggerEvent('swt_notifications:Infos','Press the number of the option you want to do')
					end
					if selection == 1 then
						print("Slected 1")
						--QBCore.ShowNotification('~r~Now you got few more baggies out of it')
						TriggerEvent('swt_notifications:Infos','Now you got few more baggies out of it')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("Slected 2")
						--QBCore.ShowNotification('~r~You are a good drug maker, your product is high quality')
						TriggerEvent('swt_notifications:Infos','You are a good drug maker, your product is high quality')
						pause = false
						quality = quality + 1
					end
					if selection == 3 then
						print("Slected 3")
						--QBCore.ShowNotification('~r~Thats a bit too much, its more glass than meth but ok')
						TriggerEvent('swt_notifications:Infos','Thats a bit too much, its more glass than meth but ok.')
						pause = false
						quality = quality - 1
					end
				end
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						quality = quality + 1
						progress = progress +  math.random(1, 2)
						--QBCore.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
						TriggerEvent('swt_notifications:Infos','Meth production: ' .. progress .. '%')
					end
				else
					TriggerEvent('qb-methcar:stop')
				end
			else
				TriggerEvent('qb-methcar:stop')
				progress = 100
				--QBCore.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
				TriggerEvent('swt_notifications:Infos','Meth Production: ' ..progress.. '%')
				--QBCore.ShowNotification('~g~~h~Production finished')
				TriggerEvent('swt_notifications:Infos','Meth Production finished')
				TriggerServerEvent('qb-methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
			end	
		end	
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('qb-methcar:stop')
					print('Stopped making drugs')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['N7']) then
				selection = 1
				--QBCore.ShowNotification('~g~Selected option number 1')
				TriggerEvent('swt_notifications:Infos','Selected option number 7')
			end
			if IsControlJustReleased(0, Keys['N8']) then
				selection = 2
				--QBCore.ShowNotification('~g~Selected option number 2')
				TriggerEvent('swt_notifications:Infos','Selected option number 8')
			end
			if IsControlJustReleased(0, Keys['N9']) then
				selection = 3
				--QBCore.ShowNotification('~g~Selected option number 3')
				TriggerEvent('swt_notifications:Infos','Selected option number 9')
			end
		end
	end
end)
