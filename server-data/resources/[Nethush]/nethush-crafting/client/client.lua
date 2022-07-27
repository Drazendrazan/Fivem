local LoggedIn = false
QBCore = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(250)
		QBCore.Functions.TriggerCallback('nethush-crafting:server:get:config', function(ConfigData)
			Config.Locations = ConfigData
		end)
		SetupWeaponInfo()
		ItemsToItemInfo()
        LoggedIn = true
    end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			NearLocation = false
			local PlayerCoords = GetEntityCoords(PlayerPedId())
			local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], true)
			if Distance < 2 then
				NearLocation = true
				DrawMarker(2, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				if IsControlJustReleased(0, 38) then
					local Crating = {}
					Crating.label = "Weapon Workbench"
					Crating.items = GetThresholdWeapons()
					TriggerServerEvent('nethush-inventory:server:set:inventory:disabled', true)
					TriggerServerEvent("nethush-inventory:server:OpenInventory", "crafting_weapon", math.random(1, 99), Crating)
				end
			end
			if not NearLocation then
				Citizen.Wait(1500)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
		    local PlayerCoords = GetEntityCoords(PlayerPedId()), true
		    local CraftObject = GetClosestObjectOfType(PlayerCoords, 2.0, -573669520, false, false, false)
		    if CraftObject ~= 0 then
		    	NearObject = false
		    	local ObjectCoords = GetEntityCoords(CraftObject)
		    	if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true) < 1.5 then
		    		NearObject = true
		    		DrawText3D(ObjectCoords.x, ObjectCoords.y, ObjectCoords.z + 1.0, "~g~E~w~ - Craft")
		    		if IsControlJustReleased(0, 38) then
						SetupWeaponInfo()
						ItemsToItemInfo()
		    			local Crating = {}
		    			Crating.label = "Crafting Workbench"
		    			Crating.items = GetThresholdItems()
						TriggerServerEvent('nethush-inventory:server:set:inventory:disabled', true)
		    			TriggerServerEvent("nethush-inventory:server:OpenInventory", "crafting", math.random(1, 99), Crating)
		    		end
		    	end
		    end
		    if not NearObject then
		    	Citizen.Wait(1000)
			end
		end
	end
end)

-- // Function \\ --

function GetThresholdItems()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if QBCore.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

function GetThresholdWeapons()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		items[k] = Config.CraftingWeapons[k]
	end
	return items
end

function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 45x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = QBCore.Shared.Items["plastic"]["label"] .. ": 16x."},
		[5] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 24x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[6] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 37x, "..QBCore.Shared.Items["copper"]["label"] .. ": 26x."},
		[7] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 33x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 44x, "..QBCore.Shared.Items["plastic"]["label"] .. ": 55x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[8] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 43x, "..QBCore.Shared.Items["plastic"]["label"] .. ": 61x."},
		[9] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 60x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = QBCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 30x."},
	}
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

function SetupWeaponInfo()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = item.description,
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingWeapons = items
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