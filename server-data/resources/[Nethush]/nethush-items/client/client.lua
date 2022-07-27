local currentVest = nil
local currentVestTexture = nil
QBCore = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
	 Citizen.Wait(250)
 end)
end)

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end) 

-- Code

RegisterNetEvent('nethush-items:client:drink')
AddEventHandler('nethush-items:client:drink', function(ItemName, PropName)
	TriggerServerEvent('QBCore:Server:RemoveItem', ItemName, 1)
	--TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items[ItemName], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('nethush-assets:addprop:with:anim', PropName, 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	QBCore.Functions.Progressbar("drink", "Drinking..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['nethush-assets']:RemoveProp()
		 TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['nethush-assets']:RemoveProp()
 		TriggerEvent("swt_notifications:Infos","Cancelled..")
		 TriggerServerEvent('QBCore:Server:AddItem', ItemName, 1)
		 --TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items[ItemName], "add")
 	end)
 end)
end)

RegisterNetEvent('nethush-items:client:drink:alcohol')
AddEventHandler('nethush-items:client:drink:alcohol', function(ItemName, PropName)
	if not exports['nethush-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['nethush-assets']:AddProp(PropName)
    			TriggerEvent('nethush-inventory:client:set:busy', true)
    			exports['nethush-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		QBCore.Functions.Progressbar("drink", "Drinking..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['nethush-assets']:RemoveProp()
    				 TriggerEvent('nethush-inventory:client:set:busy', false)
    				 TriggerServerEvent('QBCore:Server:RemoveItem', ItemName, 1)
    				 TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items[ItemName], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
             		TriggerEvent('fullsatan:GetDrunk')
 
    			 end, function()
					DoingSomething = false
    				exports['nethush-assets']:RemoveProp()
    				TriggerEvent('nethush-inventory:client:set:busy', false)
    	 			TriggerEvent("swt_notifications:Infos","Cancelled..")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('nethush-items:client:drink:slushy')
AddEventHandler('nethush-items:client:drink:slushy', function()
	TriggerServerEvent('QBCore:Server:RemoveItem', 'slushy', 1)
	--TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['slushy'], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('nethush-assets:addprop:with:anim', 'Cup', 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	QBCore.Functions.Progressbar("drink", "Drinking..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['nethush-assets']:RemoveProp()
		 TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(12, 20))
		 TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['nethush-assets']:RemoveProp()
 		TriggerEvent("swt_notifications:Infos","Cancelled..")
		 TriggerServerEvent('QBCore:Server:AddItem', 'slushy', 1)
		 --TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['slushy'], "add")
 	end)
 end)
end)

RegisterNetEvent('nethush-items:client:eat')
AddEventHandler('nethush-items:client:eat', function(ItemName, PropName)
	if not exports['nethush-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
 			Citizen.SetTimeout(1000, function()
				exports['nethush-assets']:AddProp(PropName)
				TriggerEvent('nethush-inventory:client:set:busy', true)
				exports['nethush-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				QBCore.Functions.Progressbar("eat", "Eating..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['nethush-assets']:RemoveProp()
					 TriggerEvent('nethush-inventory:client:set:busy', false)
					 TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(6, 10))
					 TriggerServerEvent('QBCore:Server:RemoveItem', ItemName, 1)
					 StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['nethush-assets']:RemoveProp()
					TriggerEvent('nethush-inventory:client:set:busy', false)
 					TriggerEvent("swt_notifications:Infos","Canceled..")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('nethush-items:client:use:armor')
AddEventHandler('nethush-items:client:use:armor', function()
 local CurrentArmor = GetPedArmour(PlayerPedId())
 if CurrentArmor <= 100 and CurrentArmor + 33 <= 100 then
	local NewArmor = CurrentArmor + 33
	if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
	TriggerServerEvent('QBCore:Server:RemoveItem', 'armor', 1)
	--TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['armor'], "remove")
     QBCore.Functions.Progressbar("vest", "Putting on vest..", 1000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
     }, {}, {}, {}, function() -- Done
   	 	 SetPedArmour(PlayerPedId(), NewArmor)
		 TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
     	 TriggerEvent("swt_notifications:Infos")
     end, function()
     	TriggerEvent("swt_notifications:Infos","Cancelled..")
		 TriggerServerEvent('QBCore:Server:AddItem', 'armor', 1)
    	 --TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['armor'], "add")
     end)
 else
	TriggerEvent("swt_notifications:Infos","You are already wearing an armor..")
 end
end)

RegisterNetEvent("nethush-items:client:use:heavy")
AddEventHandler("nethush-items:client:use:heavy", function()
	TriggerServerEvent('QBCore:Server:RemoveItem', 'heavy-armor', 1)
    local Sex = "Man"
    if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    QBCore.Functions.Progressbar("use_heavyarmor", "Putting on vest..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		--TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['heavy-armor'], "remove")
        if Sex == 'Man' then
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 0, 0, GetPedTextureVariation(PlayerPedId(), 0), 0)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
        SetPedArmour(PlayerPedId(), 100)
      else
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 9, 20, GetPedTextureVariation(PlayerPedId(), 9), 2)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
		SetPedArmour(PlayerPedId(), 100)
		TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
      end
    end)
end)

RegisterNetEvent("nethush-items:client:reset:armor")
AddEventHandler("nethush-items:client:reset:armor", function()
    local ped = PlayerPedId()
    if currentVest ~= nil and currentVestTexture ~= nil then 
        QBCore.Functions.Progressbar("remove-armor", "Taking off vest..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(PlayerPedId(), 0, currentVest, currentVestTexture, 0)
            SetPedArmour(PlayerPedId(), 0)
			QBCore.Functions.TriggerCallback('nethush-items:server:giveitem', 'heavy-armor', 1)
			TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
        end)
    else
        TriggerEvent("swt_notifications:Infos","You are not wearing a vest.")
    end
end)

RegisterNetEvent('nethush-items:client:use:repairkit')
AddEventHandler('nethush-items:client:use:repairkit', function()
	local PlayerCoords = GetEntityCoords(PlayerPedId())
	local Vehicle, Distance = QBCore.Functions.GetClosestVehicle()
	if GetVehicleEngineHealth(Vehicle) < 1000.0 then
		NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
		if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
			NewHealth = 1000.0 
		end
		if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
			local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
			if IsBackEngine(GetEntityModel(Vehicle)) then
			  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
			end
		if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
			local VehicleDoor = nil
			if IsBackEngine(GetEntityModel(Vehicle)) then
				VehicleDoor = 5
			else
				VehicleDoor = 4
			end
			SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
			TriggerServerEvent('QBCore:Server:RemoveItem', 'repairkit', 1)
			Citizen.Wait(450)
			QBCore.Functions.Progressbar("repair_vehicle", "Working On Vehicle..", math.random(10000, 20000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = "mini@repair",
				anim = "fixing_a_player",
				flags = 16,
			}, {}, {}, function() -- Done
				if math.random(1,50) < 10 then
				  TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items['repairkit'], "remove")
				end
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				TriggerEvent("swt_notifications:Infos","Vehicle has been repaired")
				SetVehicleEngineHealth(Vehicle, NewHealth) 
				for i = 1, 6 do
				 SetVehicleTyreFixed(Vehicle, i)
				end
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				TriggerEvent("swt_notifications:Infos","Failed!")
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
			end)
		end
	 else
		TriggerEvent("swt_notifications:Infos","No vehicle nearby")
	end
	end	
end)

RegisterNetEvent('nethush-items:client:dobbel')
AddEventHandler('nethush-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('nethush-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('nethush-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('nethush-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('nethush-items:client:coinflip')
AddEventHandler('nethush-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Heads'
     else
		CoinFlip = 'Coinflip: ~y~Tails'
	 end
	 TriggerEvent('nethush-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('nethush-sound:server:play:distance', 2.0, 'coin', 0.5)
		TriggerServerEvent('nethush-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('nethush-items:client:dice:anim')
AddEventHandler('nethush-items:client:dice:anim', function()
	exports['nethush-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('nethush-items:client:use:duffel-bag')
AddEventHandler('nethush-items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("nethush-inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("nethush-inventory:client:SetCurrentStash", 'tas_'..BagId)
end)
--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(rollTable, sides)
    local s = "~g~Dices~s~: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: ~g~"..total.."~s~)"
    return s
end



RegisterNetEvent('nethush-items:client:use:cigarette')
AddEventHandler('nethush-items:client:use:cigarette', function()
  Citizen.SetTimeout(1000, function()
    QBCore.Functions.Progressbar("smoke-cigarette", "Taking out a cigarette..", 4500, false, true, {
     disableMovement = false,
     disableCarMovement = false,
     disableMouse = false,
     disableCombat = true,
     }, {}, {}, {}, function() -- Done
        TriggerServerEvent('QBCore:Server:RemoveItem', 'ciggy', 1)
        TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items["ciggy"], "remove")
        TriggerEvent('nethush-items:client:smoke:effect')
        if IsPedInAnyVehicle(PlayerPedId(), false) then
			TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"smoke2"})
		end
    end)
  end)
end)

RegisterNetEvent('nethush-items:client:smoke:effect')
AddEventHandler('nethush-items:client:smoke:effect', function()
  OnWeed = true
  Time = 15
  while OnWeed do
    if Time > 0 then
     Citizen.Wait(1000)
     Time = Time - 1
     TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(1, 3))
    end
     if Time <= 0 then
      OnWeed = false
     end 
  end
end)