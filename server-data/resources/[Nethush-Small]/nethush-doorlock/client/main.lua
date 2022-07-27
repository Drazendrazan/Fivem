local DoorKey, DoorValue = nil, nil
local LoggedIn = false
local NearDoor = nil
local MaxDistance = 1.25

QBCore = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1000, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
	 Citizen.Wait(250)
	 QBCore.Functions.TriggerCallback("nethush-doorlock:server:get:config", function(config)
		Config = config
	end)
	Citizen.Wait(150)
	LoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
		     for key, Door in ipairs(Config.Doors) do
		     	if Door['Doors'] then
		     		for k,v in ipairs(Door['Doors']) do
		     			if not v.object or not DoesEntityExist(v.object) then
		     				v.object = GetClosestObjectOfType(v['ObjCoords'], 1.0, GetHashKey(v['ObjName']), false, false, false)
		     			end
		     		end
		     	else
		     		if not Door.object or not DoesEntityExist(Door.object) then
		     			Door.object = GetClosestObjectOfType(Door['ObjCoords'], 1.0, GetHashKey(Door['ObjName']), false, false, false)
		     		end
		     	end
		     end
		  Citizen.Wait(3500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if LoggedIn then
		    local playerCoords = GetEntityCoords(PlayerPedId())
		    NearDoorDistance = true
		    NearDoor = true
		    for k, Door in ipairs(Config.Doors) do
		    	local distance
		    	if Door['Doors'] then
		    		distance = #(playerCoords - Door['Doors'][1]['ObjCoords'])
		    	else
		    		distance = #(playerCoords - Door['ObjCoords'])
		    	end
		    	if Door["Distance"] then
		    		MaxDistance = Door["Distance"]
		    	end
		    	if distance < 25.0 then
		    		NearDoorDistance = false
		    		if Door['Doors'] then
		    			for _,v in ipairs(Door['Doors']) do
		    				FreezeEntityPosition(v.object, Door['Locked'])
		    				if Door['Locked'] and v['ObjYaw'] and GetEntityRotation(v.object).z ~= v['ObjYaw'] then
		    					SetEntityRotation(v.object, 0.0, 0.0, v['ObjYaw'], 2, true)
		    				end
		    			end
		    		else
		    			FreezeEntityPosition(Door.object, Door['Locked'])
		    			if Door['Locked'] and Door['ObjYaw'] and GetEntityRotation(Door.object).z ~= Door['ObjYaw'] then
		    				SetEntityRotation(Door.object, 0.0, 0.0, Door['ObjYaw'], 2, true)
		    			end
		    		end
		    	end
		    	if distance < MaxDistance then
		    		NearDoor = false
		    		DoorKey, DoorValue = k, Door
		    		if Door['Locked'] then
		    			if not Showing then
		    				Showing = true
		    				SendNUIMessage({
		    					action = "show",
		    					text = 'closed',
		    					id = k,
		    				})
		    			end
		    		elseif not Door['Locked'] then
		    			if not Showing then
		    				Showing = true
		    				SendNUIMessage({
		    					action = "show",
		    					text = 'open',
		    					id = k,
		    				})				
		    			end
		    		end
		    	end
		    end
		    if NearDoor then
		    	SendNUIMessage({
		    		action = "remove",
		    	})
		    	Showing = false
		    	Citizen.Wait(1500)
		    	DoorKey, DoorValue = nil, nil
		    end
		    if NearDoorDistance then
		    	Citizen.Wait(250)
			end
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('nethush-items:client:use:lockpick')
AddEventHandler('nethush-items:client:use:lockpick', function(IsAdvanced)
	if not NearDoor then
		if DoorValue['Locked'] then
			if DoorValue['Pickable'] then
		    	if IsAdvanced then
		    		exports['nethush-lockpick']:OpenLockpickGame(function(Success)
		    			if Success then
		    				LockpickFinish(true)
		    			else
		    				if math.random(1,100) < 15 then
		    					TriggerServerEvent('QBCore:Server:RemoveItem', 'advancedlockpick', 1)
		    					TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['advancedlockpick'], "remove")
		    				end
		    				TriggerEvent('swt_notifications:Infos','You failed..')
		    			end
					end)
					else
					 TriggerEvent('swt_notifications:Infos','This lockpick aint strong enough..')
				end
			else
				TriggerEvent('swt_notifications:Infos','This door has a massive lock on it..')
			end
		end
	end
end)

-- // Functions \\ --

function SetDoorLock(Door, key)
 OpenDoorAnimation()
 TriggerServerEvent('nethush-sound:server:play:source', 'doorlock-keys', 0.4)
 SetTimeout(1000, function()
   Door['Locked'] = not Door['Locked']
   TriggerServerEvent('nethush-doorlock:server:updateState', key, Door['Locked'])
 end)
end

-- function IsAuthorized(Door)
-- 	local PlayerData = QBCore.Functions.GetPlayerData()
-- 	for _, job in pairs(Door['Autorized']) do
-- 		if job == PlayerData.job.name then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end


function IsAuthorized(Door)
	local PlayerData = QBCore.Functions.GetPlayerData()
	for _, job in pairs(Door['Autorized']) do
		if job == PlayerData.job.name then
			return true
		end
	end
	return false
end

function CanOpenDoor()
  if not NearDoor then
	  if DoorKey ~= nil and DoorValue ~= nil then
		if IsAuthorized(DoorValue) then
		  		return true
		end
  	end
  end
end

function OpenDoorAnimation()
  exports['nethush-assets']:RequestAnimationDict("anim@heists@keycard@")
  TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
  SetTimeout(400, function()
  	ClearPedTasks(PlayerPedId())
  end)
end

function LockpickFinish(Success)
 if Success then
 	local lockpickTime = math.random(15000, 30000)
     LockpickDoorAnim(lockpickTime)
 	QBCore.Functions.Progressbar("lockpick-door", "Lockping the door..", lockpickTime, false, true, {
 		disableMovement = true,
 		disableCarMovement = true,
 		disableMouse = false,
 		disableCombat = true,
 	}, {}, {}, {}, function() -- Done
 		ClearPedTasks(PlayerPedId())
 		TriggerEvent('swt_notifications:Infos','You unlocked the door!')
 		SetDoorLock(DoorValue, DoorKey)
 	end, function() -- Cancel
 		openingDoor = false
 		ClearPedTasks(PlayerPedId())
 		TriggerEvent("swt_notifications:Infos","Process Canceled..")
 	end)
 else
     TriggerEvent('swt_notifications:Infos','You failed..')
 end
end

function LockpickDoorAnim(time)
 time = time / 1000
 exports['nethush-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
 TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
 openingDoor = true
 Citizen.CreateThread(function()
     while openingDoor do
         TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
         Citizen.Wait(1000)
         time = time - 1
         if time <= 0 then
             openingDoor = false
             StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
         end
     end
 end)
end

RegisterNetEvent('nethush-doorlock:client:setState')
AddEventHandler('nethush-doorlock:client:setState', function(Door, state)
	Config.Doors[Door]['Locked'] = state
	if not NearDoor then
	   if DoorKey == Door then
	   SendNUIMessage({
	   	action = "remove",
	   })
	   Citizen.Wait(500)
	   Showing = false
	  end
	end
end)

RegisterNetEvent('nethush-doorlock:client:toggle:locks')
AddEventHandler('nethush-doorlock:client:toggle:locks', function()
	SetDoorLock(DoorValue, DoorKey)
end)