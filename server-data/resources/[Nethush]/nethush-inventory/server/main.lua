QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

Drops = {}
Trunks = {}
Gloveboxes = {}
Stashes = {}
ShopItems = {}

RegisterServerEvent("nethush-inventory:server:LoadDrops")
AddEventHandler('nethush-inventory:server:LoadDrops', function()
	local src = source
	if next(Drops) ~= nil then
		TriggerClientEvent("nethush-inventory:client:AddDropItem", -1, dropId, source)
		TriggerClientEvent("nethush-inventory:client:AddDropItem", src, Drops)
	end
end)

RegisterServerEvent("nethush-inventory:server:addTrunkItems")
AddEventHandler('nethush-inventory:server:addTrunkItems', function(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end)

RegisterServerEvent("nethush-inventory:server:set:inventory:disabled")
AddEventHandler('nethush-inventory:server:set:inventory:disabled', function(bool)
	local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.SetMetaData("inventorydisabled", bool)
end)

function Craftable(item)
    for _, check in pairs(Config.WhitelistedItems) do
        if check == item then
            return true
        end
    end
    return false
end

RegisterServerEvent("nethush-inventory:server:combineItem")
AddEventHandler('nethush-inventory:server:combineItem', function(item, fromItem, toItem, RemoveToItem)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local CombineFrom = Player.Functions.GetItemByName(fromItem)
	local CombineTo = Player.Functions.GetItemByName(toItem)
	local GetItemData = QBCore.Shared.Items[item]

	if CombineFrom ~= nil and CombineTo ~= nil then
		if Craftable(item) then

				if GetItemData['type'] == 'weapon' then
					local Info = {quality = 100.0, melee = false, ammo = 2}
					if GetItemData['ammotype'] == nil or GetItemData['ammotype'] == 'nil' then
						Info = {quality = 100.0, melee = true}
						Player.Functions.AddItem(item, 1, false, Info)
					else
						Player.Functions.AddItem(item, 1, false, Info)
					end
				else
					Player.Functions.AddItem(item, 1)
				end
				Player.Functions.RemoveItem(fromItem, 1)
			if RemoveToItem then
				Player.Functions.RemoveItem(toItem, 1)
			end
			Player.Functions.SetMetaData("inventorydisabled", false)
			TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
		else
		QBCore.Functions.BanInjection(source, 'Items spawned that were not whitelisted.')
		end
	else
	  TriggerClientEvent('swt_notifications:Infos', src, "How are you supposed to do this with out the needed items?")
	end
end)

RegisterServerEvent("nethush-inventory:server:CraftItems")
AddEventHandler('nethush-inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		Player.Functions.AddItem(itemName, amount, toSlot)
		Player.Functions.SetMetaData("inventorydisabled", false)
		if points ~= nil then
			Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+(points*amount))
		end
		TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("nethush-inventory:server:CraftWeapon")
AddEventHandler('nethush-inventory:server:CraftWeapon', function(ItemName, itemCosts, amount, toSlot, ItemType)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	if ItemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.Functions.RemoveItem(k, (v*amount))
		end
		if ItemType == 'weapon' then
		  Player.Functions.AddItem(ItemName, amount, toSlot, {serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4)), ammo = 1, quality = 100.0})
		else
		  Player.Functions.AddItem(ItemName, amount, toSlot)
		end
		Player.Functions.SetMetaData("inventorydisabled", false)
		TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("nethush-inventory:server:SetIsOpenState")
AddEventHandler('nethush-inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if not IsOpen then
		if type == "stash" then
			Stashes[id].isOpen = false
		elseif type == "trunk" then
			Trunks[id].isOpen = false
		elseif type == "glovebox" then
			Gloveboxes[id].isOpen = false
		end
	end
end)

RegisterServerEvent("nethush-inventory:server:OpenInventory")
AddEventHandler('nethush-inventory:server:OpenInventory', function(name, id, other)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
		if name ~= nil and id ~= nil then
			local secondInv = {}
			if name == "stash" then
				if Stashes[id] ~= nil then
					if Stashes[id].isOpen then
						local Target = QBCore.Functions.GetPlayer(Stashes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('nethush-inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
						else
							Stashes[id].isOpen = false
						end
					end
				end
				local maxweight = 1000000
				local slots = 50
				if other ~= nil then 
					maxweight = other.maxweight ~= nil and other.maxweight or 1000000
					slots = other.slots ~= nil and other.slots or 50
				end
				secondInv.name = "stash-"..id
				secondInv.label = "Stash-"..id
				secondInv.maxweight = maxweight
				secondInv.inventory = {}
				secondInv.slots = slots
				if Stashes[id] ~= nil and Stashes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Stash-Geen"
					secondInv.maxweight = 1000000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local stashItems = GetStashItems(id)
					if next(stashItems) ~= nil then
						secondInv.inventory = stashItems
						Stashes[id] = {}
						Stashes[id].items = stashItems
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					else
						Stashes[id] = {}
						Stashes[id].items = {}
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					end
				end
			elseif name == "trunk" then
				if Trunks[id] ~= nil then
					if Trunks[id].isOpen then
						local Target = QBCore.Functions.GetPlayer(Trunks[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('nethush-inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
						else
							Trunks[id].isOpen = false
						end
					end
				end
				secondInv.name = "trunk-"..id
				secondInv.label = "Trunk-"..id
				secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = other.slots ~= nil and other.slots or 50
				if (Trunks[id] ~= nil and Trunks[id].isOpen) or (QBCore.Shared.SplitStr(id, "PLZI")[2] ~= nil and Player.PlayerData.job.name ~= "police") then
					secondInv.name = "none-inv"
					secondInv.label = "Trunk-Geen"
					secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					if id ~= nil then 
						local ownedItems = GetOwnedVehicleItems(id)
						if IsVehicleOwned(id) and next(ownedItems) ~= nil then
							secondInv.inventory = ownedItems
							Trunks[id] = {}
							Trunks[id].items = ownedItems
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						elseif Trunks[id] ~= nil and not Trunks[id].isOpen then
							secondInv.inventory = Trunks[id].items
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						else
							Trunks[id] = {}
							Trunks[id].items = {}
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						end
					end
				end
			elseif name == "glovebox" then
				if Gloveboxes[id] ~= nil then
					if Gloveboxes[id].isOpen then
						local Target = QBCore.Functions.GetPlayer(Gloveboxes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('nethush-inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
						else
							Gloveboxes[id].isOpen = false
						end
					end
				end
				secondInv.name = "glovebox-"..id
				secondInv.label = "Dashboard-"..id
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 5
				if Gloveboxes[id] ~= nil and Gloveboxes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Dashboard-Geen"
					secondInv.maxweight = 10000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local ownedItems = GetOwnedVehicleGloveboxItems(id)
					if Gloveboxes[id] ~= nil and not Gloveboxes[id].isOpen then
						secondInv.inventory = Gloveboxes[id].items
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) ~= nil then
						secondInv.inventory = ownedItems
						Gloveboxes[id] = {}
						Gloveboxes[id].items = ownedItems
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					else
						Gloveboxes[id] = {}
						Gloveboxes[id].items = {}
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					end
				end
			elseif name == "shop" then
				secondInv.name = "itemshop-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = SetupShopItems(id, other.items)
				ShopItems[id] = {}
				ShopItems[id].items = other.items
				secondInv.slots = #other.items
			elseif name == "crafting" then
				secondInv.name = "crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "methcrafting" then
				secondInv.name = "methcrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "cokecrafting" then
				secondInv.name = "cokecrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "crafting_weapon" then
				secondInv.name = "crafting_weapon"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "lab" then
				secondInv.name = "lab-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = other.slots
			elseif name == "otherplayer" then
				local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(id))
				if OtherPlayer ~= nil then
					secondInv.name = "otherplayer-"..id
					secondInv.label = "Player-"..id
					secondInv.maxweight = QBCore.Config.Player.MaxWeight
					secondInv.inventory = OtherPlayer.PlayerData.items
					secondInv.slots = Config.MaxInventorySlots
					Citizen.Wait(250)
				end
			else
				if Drops[id] ~= nil and not Drops[id].isOpen then
					secondInv.name = id
					secondInv.label = "Ground-"..tostring(id)
					secondInv.maxweight = 100000
					secondInv.inventory = Drops[id].items
					secondInv.slots = 15
					Drops[id].isOpen = src
					Drops[id].label = secondInv.label
				else
					secondInv.name = "none-inv"
					secondInv.label = "Ground-Geen"
					secondInv.maxweight = 100000
					secondInv.inventory = {}
					secondInv.slots = 0
				end
			end
			TriggerClientEvent("nethush-inventory:client:OpenInventory", src, Player.PlayerData.items, secondInv)
		else
			TriggerClientEvent("nethush-inventory:client:OpenInventory", src, Player.PlayerData.items)
		end
end)

RegisterServerEvent("nethush-inventory:server:SaveInventory")
AddEventHandler('nethush-inventory:server:SaveInventory', function(type, id)
	if type == "trunk" then
		if (IsVehicleOwned(id)) then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == "glovebox" then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)
	elseif type == "drop" then
		if Drops[id] ~= nil then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent("nethush-inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

RegisterServerEvent("nethush-inventory:server:UseItemSlot")
AddEventHandler('nethush-inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData ~= nil then
		local itemInfo = QBCore.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality ~= nil then
				if itemData.info.quality ~= 0 then
					TriggerClientEvent("nethush-inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent('swt_notifications:Infos', src, "Weapon is broken.")
				end
			else
				TriggerClientEvent('swt_notifications:Infos', src, "No weapon quality found.", "info")
			end
			TriggerClientEvent('nethush-inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
			TriggerClientEvent('nethush-inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)

RegisterServerEvent("nethush-inventory:server:UseItem")
AddEventHandler('nethush-inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData ~= nil then
			TriggerClientEvent('nethush-inventory:client:ItemBox', src, QBCore.Shared.Items[itemData.name], "use")
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end
	end
end)

RegisterServerEvent("nethush-inventory:server:SetInventoryData")
AddEventHandler('nethush-inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local fromSlot = tonumber(fromSlot)
	local toSlot = tonumber(toSlot)

	if (fromInventory == "player" or fromInventory == "hotbar") and (QBCore.Shared.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
		return
	end

	if fromInventory == "player" or fromInventory == "hotbar" then
		local fromItemData = Player.Functions.GetItemBySlot(fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "otherplayer" then
				local playerId = tonumber(QBCore.Shared.SplitStr(toInventory, "-")[2])
				local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, fromSlot)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "robbing", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					--TriggerEvent("qb-log:server:SendLog", "robbing", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
				local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Trunks[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "trunk", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					--TriggerEvent("qb-log:server:SendLog", "trunk", "dropped Item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
				local plate = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Gloveboxes[plate].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "glovebox", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					--TriggerEvent("qb-log:server:SendLog", "glovebox", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - Registration number: *" .. plate .. "*")
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "stash" then
				local stashId = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Stashes[stashId].items[toSlot]
				Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.PlayerData.items[fromSlot] = toItemData
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
						Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					--TriggerEvent("qb-log:server:SendLog", "stash", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "lab" then
				local LabId = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = exports['nethush-labs']:GetInventoryData(LabId, toSlot)
				local IsItemValid = exports['nethush-labs']:CanItemBePlaced(fromItemData.name:lower())
				if IsItemValid then
					TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							exports['nethush-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info, false)
						end
					end
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					if toSlot ~= 2 then
						Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
						exports['nethush-labs']:AddProduct(LabId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, true)
					else
						TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
						TriggerClientEvent("nethush-inventory:client:close:inventory", src)
					end
				else
					TriggerClientEvent('swt_notifications:Infos', src, "This can not go in here..")
					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent("nethush-inventory:client:close:inventory", src)
				end
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromAmount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("nethush-inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toAmount)
							--TriggerEvent("qb-log:server:SendLog", "drop", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** to: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
						end
					else
						local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
						--TriggerEvent("qb-log:server:SendLog", "drop", "Dropped item", "red", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) New dropped item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
					end
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
					if itemInfo["name"] == "radio" then
					TriggerClientEvent('qb-radio:onRadioDrop', src)

					end
				end
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Je hebt dit item niet!")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "otherplayer" then
		local playerId = tonumber(QBCore.Shared.SplitStr(fromInventory, "-")[2])
		local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
		local fromItemData = OtherPlayer.PlayerData.items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				TriggerClientEvent("nethush-inventory:client:CheckWeapon", OtherPlayer.PlayerData.source, fromItemData.name)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "robbing", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "robbing", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (CID: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				OtherPlayer.Functions.RemoveItem(itemInfo["name"], fromAmount, fromSlot)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, toSlot)
						OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				OtherPlayer.Functions.AddItem(itemInfo["name"], fromAmount, toSlot, fromItemData.info)
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
		local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Trunks[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "trunk", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** Registration number: *" .. plate .. "*")
					else
						TriggerEvent("server:sendLog", Player.PlayerData.citizenid, "itemswapped", {type="2trunk3", name=toItemData.name, amount=toAmount, target=plate})
						--TriggerEvent("qb-log:server:SendLog", "trunk", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from Registration number: *" .. plate .. "*")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "trunk", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** Registration number: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Trunks[plate].items[toSlot]
				RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo["name"], toAmount)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist??")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
		local plate = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Gloveboxes[plate].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "glovebox", "Gewisseld", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src..")* Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** Registration number: *" .. plate .. "*")
					else
						--TriggerEvent("qb-log:server:SendLog", "glovebox", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item: name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from Registration number: *" .. plate .. "*")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "glovebox", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** Registration number: *" .. plate .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toAmount)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist??")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
		local stashId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						--TriggerEvent("qb-log:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
					else
						--TriggerEvent("qb-log:server:SendLog", "stash", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. stashId .. "*")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "stash", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. stashId .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist??")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "lab" then
		local LabId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = exports['nethush-labs']:GetInventoryData(LabId, fromSlot)
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				exports['nethush-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						if toSlot ~= 2 then
							Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
							exports['nethush-labs']:AddProduct(LabId, fromSlot, itemInfo["name"], toAmount, toItemData.info, true)
							--TriggerEvent("qb-log:server:SendLog", "stash", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. LabId .. "*")
						else
							TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
						end
					else
						--TriggerEvent("qb-log:server:SendLog", "stash", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. LabId .. "*")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "stash", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. LabId .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = exports['nethush-labs']:GetInventoryData(LabId, toSlot)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						exports['nethush-labs']:RemoveProduct(LabId, toSlot, itemInfo["name"], toAmount)
						exports['nethush-labs']:AddProduct(LabId, fromSlot, itemInfo["name"], toAmount, toItemData.info, true)
					end
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				if toSlot ~= 2 then
					exports['nethush-labs']:RemoveProduct(LabId, fromSlot, itemInfo["name"], fromAmount)
					exports['nethush-labs']:AddProduct(LabId, toSlot, itemInfo["name"], fromAmount, fromItemData.info, src)
				else
					TriggerClientEvent("nethush-inventory:client:close:inventory", src)
					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				end
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist??")
		end
	elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "itemshop" then
		local shopType = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local bankBalance = Player.PlayerData.money["bank"]
		local price = tonumber((itemData.price*fromAmount))
		if QBCore.Shared.SplitStr(shopType, "_")[1] == "Dealer" then
			if QBCore.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
				price = tonumber(itemData.price)
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					itemData.info.quality = 100.0
				    itemData.info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
					Player.Functions.AddItem(itemData.name, 1, toSlot, itemData.info)
					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
					TriggerClientEvent('nethush-dealers:client:update:dealer:items', src, itemData, 1)
					TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


					--TriggerEvent("qb-log:server:SendLog", "dealers", "Dealer item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
				else
					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

				end
			else
				if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
					Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
					TriggerClientEvent('nethush-dealers:client:update:dealer:items', src, itemData, fromAmount)
					TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
					--TriggerEvent("qb-log:server:SendLog", "dealers", "Dealer item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
				else
					TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

				end
			end
		elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "custom" then
			if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

			end
		elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "police" then
			if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

			end
		elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "Itemshop" then
			if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
				if itemData.name == 'duffel-bag' then itemData.info.bagid = math.random(11111,99999) elseif itemData.name == 'burger-box' then itemData.info.boxid = math.random(11111,99999) end	
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('nethush-stores:client:update:store', src, itemData, fromAmount)
				TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


				--TriggerEvent("qb-log:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

			end
		elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "Cokebrick" then
			if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("nethush-inventory:client:close:inventory", src)
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
				--TriggerEvent("qb-log:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
			end
		elseif QBCore.Shared.SplitStr(shopType, "_")[1] == "StreetDealer" then
			if Player.Functions.RemoveItem('money-roll', price) then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


				--TriggerEvent("qb-log:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				--TriggerClientEvent('swt_notifications:Infos', src, "You do not have enough money rolls")
				TriggerClientEvent("swt_notifications:Negative","SLMC SYstem","You do not have enough money rolls","right",8000,true)

			end
		else
			if Player.Functions.RemoveMoney("cash", price, "unkown-itemshop-bought-item") then
				Player.Functions.AddItem(itemData.name, fromAmount, toSlot, itemData.info)
				TriggerClientEvent("swt_notifications:Info",src,"SLMC System",itemInfo["label"] .. " bought!","top-right",3000,true)


				--TriggerEvent("qb-log:server:SendLog", "shops", "Shop item purchased", "green", "**"..GetPlayerName(src) .. "** Bought a " .. itemInfo["label"] .. " purchased for $"..price)
			else
				TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent("swt_notifications:Negative","SLMC SYstem",'You dont have enough cash..',"right",8000,true)

			end
		end
	elseif fromInventory == "crafting" then
		local itemData = exports['nethush-crafting']:GetCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("nethush-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.points)
		else
			TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('swt_notifications:Infos', src, "You do not have the required items")
		end
	elseif fromInventory == "crafting_weapon" then
		local itemData = exports['nethush-crafting']:GetWeaponCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("nethush-inventory:client:CraftWeapon", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('swt_notifications:Infos', src, "You do not have the required items")
		end
	elseif fromInventory == "cokecrafting" then
		local itemData = exports['nethush-labs']:GetCokeCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("nethush-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('swt_notifications:Infos', src, "You do not have the required items")
		end
	elseif fromInventory == "methcrafting" then
		local itemData = exports['nethush-labs']:GetMethCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromAmount) then
			Player.Functions.SetMetaData("inventorydisabled", true)
			TriggerClientEvent("nethush-inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, itemData.type)
		else
			TriggerClientEvent("nethush-inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('swt_notifications:Infos', src, "You do not have the required items")
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
						TriggerClientEvent('qb-radio:onRadioDrop', src)

						end
						--TriggerEvent("qb-log:server:SendLog", "drop", "Swapped item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
					else
						--TriggerEvent("qb-log:server:SendLog", "drop", "Stacked item", "orange", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) Stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** - from dropid: *" .. fromInventory .. "*")
					end
				else
					--TriggerEvent("qb-log:server:SendLog", "drop", "Recieved Item", "green", "**".. GetPlayerName(src) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** -  dropid: *" .. fromInventory .. "*")
				end
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toAmount)
						AddToDrop(fromInventory, fromSlot, itemInfo["name"], toAmount, toItemData.info)
						if itemInfo["name"] == "radio" then
						TriggerClientEvent('qb-radio:onRadioDrop', src)

						end
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, fromItemData.info)
				if itemInfo["name"] == "radio" then
			    TriggerClientEvent('qb-radio:onRadioDrop', src)

				end
			end
		else
			TriggerClientEvent("swt_notifications:Infos", src, "Item does not exist")
		end
	end
end)

function hasCraftItems(source, CostItems, amount)
	local Player = QBCore.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v * amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function IsVehicleOwned(plate)
	local val = false
	QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end

-- Shop Items
function SetupShopItems(shop, shopItems)
	local items = {}
	if shopItems ~= nil and next(shopItems) ~= nil then
		for k, item in pairs(shopItems) do
			local itemInfo = QBCore.Shared.Items[item.name:lower()]
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				info = item.info ~= nil and item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				price = item.price,
				image = itemInfo["image"],
				slot = item.slot,
			}
		end
	end
	return items
end

-- Stash Items
function GetStashItems(stashId)
	local items = {}
		QBCore.Functions.ExecuteSql(true, "SELECT * FROM `stashitemsnew` WHERE `stash` = '"..stashId.."'", function(result)
			if result[1] ~= nil then 
				if result[1].items ~= nil then
					result[1].items = json.decode(result[1].items)
					if result[1].items ~= nil then 
						for k, item in pairs(result[1].items) do
							local itemInfo = QBCore.Shared.Items[item.name:lower()]
							items[item.slot] = {
								name = itemInfo["name"],
								amount = tonumber(item.amount),
								info = item.info ~= nil and item.info or "",
								label = itemInfo["label"],
								description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
								weight = itemInfo["weight"], 
								type = itemInfo["type"], 
								unique = itemInfo["unique"], 
								useable = itemInfo["useable"], 
								image = itemInfo["image"],
								slot = item.slot,
							}
						end
					end
				end
			end
		end)
	return items
end

QBCore.Functions.CreateCallback('nethush-inventory:server:GetStashItems', function(source, cb, stashId)
	cb(GetStashItems(stashId))
end)

RegisterServerEvent('nethush-inventory:server:SaveStashItems')
AddEventHandler('nethush-inventory:server:SaveStashItems', function(stashId, items)
	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `stashitemsnew` WHERE `stash` = '"..stashId.."'", function(result)
		if result[1] ~= nil then
			QBCore.Functions.ExecuteSql(false, "UPDATE `stashitemsnew` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
		else
			QBCore.Functions.ExecuteSql(false, "INSERT INTO `stashitemsnew` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
		end
	end)
end)

function SaveStashItems(stashId, items)
	if Stashes[stashId].label ~= "Stash-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end
			QBCore.Functions.ExecuteSql(false, "SELECT * FROM `stashitemsnew` WHERE `stash` = '"..stashId.."'", function(result)
				if result[1] ~= nil then
					QBCore.Functions.ExecuteSql(false, "UPDATE `stashitemsnew` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
					Stashes[stashId].isOpen = false
				else
					QBCore.Functions.ExecuteSql(false, "INSERT INTO `stashitemsnew` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
					Stashes[stashId].isOpen = false
				end
			end)
		end
	end
end

function AddToStash(stashId, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = QBCore.Shared.Items[itemName]
	if not ItemData.unique then
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromStash(stashId, slot, itemName, amount)
	local amount = tonumber(amount)
	if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
			if next(Stashes[stashId].items) == nil then
				Stashes[stashId].items = {}
			end
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

-- Trunk items
function GetOwnedVehicleItems(plate)
	local items = {}
	QBCore.Functions.ExecuteSql(true, "SELECT * FROM `trunkitems` WHERE `plate` = '"..plate.."'", function(result)
		if result[1] ~= nil then
			for k, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = json.decode(item.info) ~= nil and json.decode(item.info) or "",
					label = itemInfo["label"],
					description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
					weight = itemInfo["weight"], 
					type = itemInfo["type"], 
					unique = itemInfo["unique"], 
					useable = itemInfo["useable"], 
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
			QBCore.Functions.ExecuteSql(false, "DELETE FROM `trunkitems` WHERE `plate` = '"..plate.."'")
		else
			QBCore.Functions.ExecuteSql(true, "SELECT * FROM `trunkitemsnew` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					if result[1].items ~= nil then
						result[1].items = json.decode(result[1].items)
						if result[1].items ~= nil then 
							for k, item in pairs(result[1].items) do
								local itemInfo = QBCore.Shared.Items[item.name:lower()]
								items[item.slot] = {
									name = itemInfo["name"],
									amount = tonumber(item.amount),
									info = item.info ~= nil and item.info or "",
									label = itemInfo["label"],
									description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
									weight = itemInfo["weight"], 
									type = itemInfo["type"], 
									unique = itemInfo["unique"], 
									useable = itemInfo["useable"], 
									image = itemInfo["image"],
									slot = item.slot,
								}
							end
						end
					end
				end
			end)
		end
	end)
	return items
end

function SaveOwnedVehicleItems(plate, items)
	if Trunks[plate].label ~= "Trunk-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			QBCore.Functions.ExecuteSql(false, "SELECT * FROM `trunkitemsnew` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					QBCore.Functions.ExecuteSql(false, "UPDATE `trunkitemsnew` SET `items` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Trunks[plate].isOpen = false
					end)
				else
					QBCore.Functions.ExecuteSql(false, "INSERT INTO `trunkitemsnew` (`plate`, `items`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Trunks[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToTrunk(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = QBCore.Shared.Items[itemName]

	if not ItemData.unique then
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromTrunk(plate, slot, itemName, amount)
	if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
			if next(Trunks[plate].items) == nil then
				Trunks[plate].items = {}
			end
		end
	else
		Trunks[plate].items[slot]= nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end

-- Glovebox items
function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	QBCore.Functions.ExecuteSql(true, "SELECT * FROM `gloveboxitems` WHERE `plate` = '"..plate.."'", function(result)
		if result[1] ~= nil then
			for k, item in pairs(result) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = json.decode(item.info) ~= nil and json.decode(item.info) or "",
					label = itemInfo["label"],
					description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
					weight = itemInfo["weight"], 
					type = itemInfo["type"], 
					unique = itemInfo["unique"], 
					useable = itemInfo["useable"], 
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
			QBCore.Functions.ExecuteSql(false, "DELETE FROM `gloveboxitems` WHERE `plate` = '"..plate.."'")
		else
			QBCore.Functions.ExecuteSql(true, "SELECT * FROM `gloveboxitemsnew` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then 
					if result[1].items ~= nil then
						result[1].items = json.decode(result[1].items)
						if result[1].items ~= nil then 
							for k, item in pairs(result[1].items) do
								local itemInfo = QBCore.Shared.Items[item.name:lower()]
								items[item.slot] = {
									name = itemInfo["name"],
									amount = tonumber(item.amount),
									info = item.info ~= nil and item.info or "",
									label = itemInfo["label"],
									description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
									weight = itemInfo["weight"], 
									type = itemInfo["type"], 
									unique = itemInfo["unique"], 
									useable = itemInfo["useable"], 
									image = itemInfo["image"],
									slot = item.slot,
								}
							end
						end
					end
				end
			end)
		end
	end)
	return items
end

function SaveOwnedGloveboxItems(plate, items)
	if Gloveboxes[plate].label ~= "Glovebox-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			QBCore.Functions.ExecuteSql(false, "SELECT * FROM `gloveboxitemsnew` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					QBCore.Functions.ExecuteSql(false, "UPDATE `gloveboxitemsnew` SET `items` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				else
					QBCore.Functions.ExecuteSql(false, "INSERT INTO `gloveboxitemsnew` (`plate`, `items`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToGlovebox(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = QBCore.Shared.Items[itemName]

	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info ~= nil and info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = slot,
			}
		end
	end
end

function RemoveFromGlovebox(plate, slot, itemName, amount)
	if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
			if next(Gloveboxes[plate].items) == nil then
				Gloveboxes[plate].items = {}
			end
		end
	else
		Gloveboxes[plate].items[slot]= nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end

-- Drop items
function AddToDrop(dropId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = QBCore.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info ~= nil and info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = slot,
			id = dropId,
		}
	end
end

function RemoveFromDrop(dropId, slot, itemName, amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

function CreateDropId()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

function CreateNewDrop(source, fromSlot, toSlot, itemAmount)
	local Player = QBCore.Functions.GetPlayer(source)
	local itemData = Player.Functions.GetItemBySlot(fromSlot)
	if Player.Functions.RemoveItem(itemData.name, itemAmount, itemData.slot) then
		TriggerClientEvent("nethush-inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info ~= nil and itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = toSlot,
			id = dropId,
		}
		--TriggerEvent("qb-log:server:SendLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (CID: *"..Player.PlayerData.citizenid.."* | id: *"..source.."*) New dropped item; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
		TriggerClientEvent("nethush-inventory:client:DropItemAnim", source)
		TriggerClientEvent("nethush-inventory:client:AddDropItem", -1, dropId, source)
		if itemData.name:lower() == "radio" then
			TriggerClientEvent('qb-radio:onRadioDrop', source)
		end
	else
		TriggerClientEvent("swt_notifications:Infos", src, "You dont have this item.")
		return
	end
end

QBCore.Commands.Add("resetinv", "Reset inventory (in case for -None)", {{name="type", help="stash/trunk/glovebox"},{name="id/plate", help="ID of stash or licenseplate"}}, true, function(source, args)
	local invType = args[1]:lower()
	table.remove(args, 1)
	local invId = table.concat(args, " ")
	if invType ~= nil and invId ~= nil then 
		if invType == "trunk" then
			if Trunks[invId] ~= nil then 
				Trunks[invId].isOpen = false
			end
		elseif invType == "glovebox" then
			if Gloveboxes[invId] ~= nil then 
				Gloveboxes[invId].isOpen = false
			end
		elseif invType == "stash" then
			if Stashes[invId] ~= nil then 
				Stashes[invId].isOpen = false
			end
		else
			TriggerClientEvent('swt_notifications:Infos', source,  "No valid type.")
		end
	else
		TriggerClientEvent('swt_notifications:Infos', source,  "Please fill in all arguments.")
	end
end, "admin")

QBCore.Commands.Add("giveitem", "Give item to player.", {{name="id", help="CID"},{name="item", help="name of item (not label)"}, {name="Amount", help="Amount"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
	if Player ~= nil then
		if amount > 0 then
			if itemData ~= nil then
				local info = {}
				if itemData["name"] == "id-card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.quality = 100.0
					info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
				elseif itemData["name"] == 'markedbills' then
					info.worth = math.random(3000,5000)
				elseif itemData['name'] == 'burger-box' then
					info.boxid = math.random(11111,99999)
				elseif itemData['name'] == 'duffel-bag' then
					info.bagid = math.random(11111,99999)
				end
				if Player.Functions.AddItem(itemData["name"], amount, false, info) then
					TriggerClientEvent('nethush-inventory:client:ItemBox', tonumber(args[1]), QBCore.Shared.Items[itemData["name"]], 'add')
					TriggerClientEvent('swt_notifications:Infos', source, "You gave " ..GetPlayerName(tonumber(args[1])).." to " .. itemData["name"] .. " ("..amount.. ")")
				else
					TriggerClientEvent('swt_notifications:Infos', source,  "Can not give this item, inventory full?")
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Item does not exist")
			end
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Amount must be higher then 0.")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Citizen not available.")
	end
end, "admin")

QBCore.Functions.CreateUseableItem("id_card", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	local photo = nil

	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(results)
		-- Looping through results:
		for k,v in pairs(results) do

				photo = v.photo
				
				if Player.Functions.GetItemBySlot(item.slot) ~= nil then
					TriggerClientEvent("nethush-inventory:client:ShowId", -1, source, Player.PlayerData.citizenid, item.info, photo)
				end
		end
	end)		
end)

QBCore.Functions.CreateUseableItem("driver_license", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(results)
		-- Looping through results:
		for k,v in pairs(results) do

				photo = v.photo
				print(Player.PlayerData.citizenid)
				if Player.Functions.GetItemBySlot(item.slot) ~= nil then
					TriggerClientEvent("nethush-inventory:client:ShowDriverLicense", -1, source, Player.PlayerData.citizenid, item.info, photo)
				end
		end
	end)	
end)