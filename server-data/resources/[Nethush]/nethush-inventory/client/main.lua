local QBCore = nil
local LoggedIn = true

local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local CurrentTrash = false   

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)  

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
     Citizen.Wait(250)
     Config.InventoryBusy = false
     LoggedIn = true
 end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    Config.InventoryBusy = false
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        if LoggedIn then
           if IsDisabledControlJustPressed(0, Config.Keys["TAB"]) and not Config.InventoryBusy then
            --Config.InventoryBusy = true
               local DumpsterFound = ClosestContainer()
               local JailContainerFound = ClosestJailContainer()
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                       local curVeh = nil
                       if IsPedInAnyVehicle(PlayerPedId()) then
                           local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                           CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                           curVeh = vehicle
                           CurrentVehicle = nil
                       else
                           local vehicle = QBCore.Functions.GetClosestVehicle()
                           if vehicle ~= 0 and vehicle ~= nil then
                               local pos = GetEntityCoords(PlayerPedId())
                               local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                               if (IsBackEngine(GetEntityModel(vehicle))) then
                                   trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                               end
                               if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 1.0) and not IsPedInAnyVehicle(PlayerPedId()) then
                                   if GetVehicleDoorLockStatus(vehicle) < 2 then
                                       CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                       curVeh = vehicle
                                       CurrentGlovebox = nil
                                   else
                                       TriggerEvent("swt_notifications:Infos","Vehicle Locked.")
                                       return
                                   end
                               else
                                   CurrentVehicle = nil
                               end
                           else
                               CurrentVehicle = nil
                           end
                       end
                       if CurrentVehicle ~= nil then
                           local other = {maxweight = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxWeight'], slots = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxSlots']}
                           TriggerServerEvent("nethush-inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                           OpenTrunk()
                       elseif CurrentGlovebox ~= nil then
                           TriggerServerEvent("nethush-inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                       elseif DumpsterFound then
                           local Dumpster = 'Container | '..math.floor(DumpsterFound.x).. ' | '..math.floor(DumpsterFound.y)..' |'
                           TriggerServerEvent("nethush-inventory:server:OpenInventory", "stash", Dumpster, {maxweight = 1000000, slots = 15})
                           TriggerEvent("nethush-inventory:client:SetCurrentStash", Dumpster)
                           TriggerEvent('nethush-inventory:client:open:anim')   
                       elseif CurrentDrop ~= 0 then
                           TriggerServerEvent("nethush-inventory:server:OpenInventory", "drop", CurrentDrop)
                       else                       
                           TriggerServerEvent("nethush-inventory:server:OpenInventory")
                           TriggerEvent('nethush-inventory:client:open:anim')
                       end
                   end
               end)
           end
            
           if IsControlJustPressed(0, Config.Keys["Z"]) then
               ToggleHotbar(true)
           end
   
           if IsControlJustReleased(0, Config.Keys["Z"]) then
               ToggleHotbar(false)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["1"]) then
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("nethush-inventory:server:UseItemSlot", 1)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["2"]) then
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("nethush-inventory:server:UseItemSlot", 2)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["3"]) then
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("nethush-inventory:server:UseItemSlot", 3)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["4"]) then
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("nethush-inventory:server:UseItemSlot", 4)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["5"]) then
               QBCore.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("nethush-inventory:server:UseItemSlot", 5)
                   end
               end)
           end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z -0.5, 0, 0, 0, 0, 0, 0, 0.35, 0.5, 0.15, 252, 255, 255, 91, 0, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    TriggerEvent("swt_notifications:Infos",Data.message, data.type)
end)

RegisterNUICallback('UseItemShiftClick', function(slot)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
            SendNUIMessage({
                action = "close",
            })
            SetNuiFocus(false, false)
            Config.HasInventoryOpen = false
            Citizen.Wait(250)
            TriggerServerEvent("nethush-inventory:server:UseItemSlot", slot.slot)
        end
    end)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = QBCore.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = QBCore.Shared.Items[data.WeaponData.name]
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    
    QBCore.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(QBCore.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "trunk", CurrentVehicle)
        TriggerEvent('nethush-inventory:client:open:anim')
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "stash", CurrentStash)
        TriggerEvent('nethush-inventory:client:open:anim')
        CurrentStash = nil
    else
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "drop", CurrentDrop)
        TriggerEvent('nethush-inventory:client:open:anim')
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    Config.HasInventoryOpen = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TriggerServerEvent('nethush-inventory:server:set:inventory:disabled', false)
    --Citizen.Wait(2600)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("nethush-inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("UpdateStash", function(data, cb)
    if CurrentVehicle ~= nil then
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "trunk", CurrentVehicle)
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
    elseif CurrentStash ~= nil then
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "stash", CurrentStash)
    else
        TriggerServerEvent("nethush-inventory:server:SaveInventory", "drop", CurrentDrop)
    end
end)

RegisterNUICallback("combineItem", function(data)
 Citizen.Wait(150)
 TriggerServerEvent('nethush-inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
 TriggerEvent('nethush-inventory:client:ItemBox', QBCore.Shared.Items[data.reward], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    TriggerServerEvent('nethush-inventory:server:set:inventory:disabled', true)
    Citizen.SetTimeout(1250, function()
        Config.InventoryBusy = true
        QBCore.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = aDict,
            anim = aLib,
            flags = 49,
        }, {}, {}, function() -- Done
            Config.InventoryBusy = false
            StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
            TriggerServerEvent('nethush-inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem, combineData.RemoveToItem)
        end, function() -- Cancel
            Config.InventoryBusy = false
            StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
            TriggerEvent("swt_notifications:Infos","Failed!")
        end)
    end)
    
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("nethush-inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

-- // Events \\ --
RegisterNetEvent('nethush-inventory:client:close:inventory')
AddEventHandler('nethush-inventory:client:close:inventory', function()
    TriggerServerEvent('nethush-inventory:server:set:inventory:disabled', false)
    Citizen.SetTimeout(150, function()
        SendNUIMessage({
            action = "close",
        })
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
    end)
end)

RegisterNetEvent('nethush-inventory:client:set:busy')
AddEventHandler('nethush-inventory:client:set:busy', function(bool)
    Config.InventoryBusy = bool
end)

RegisterNetEvent('nethush-inventory:client:CheckOpenState')
AddEventHandler('nethush-inventory:client:CheckOpenState', function(type, id, label)
    local name = QBCore.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('nethush-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('nethush-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('nethush-inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent("nethush-inventory:bag:UseBag")
AddEventHandler("nethush-inventory:bag:UseBag", function()
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    print('Bag is Opining')
    TriggerEvent("swt_notifications:Infos","opening bag..")
    QBCore.Functions.Progressbar("use_bag", "Opening Bag", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local BagData = {
            outfitData = {
                ["bag"]   = { item = 41, texture = 0},  -- Nek / Das
            }
        }
        --TriggerEvent('qb-clothing:client:loadOutfit', BagData) // Old Clothing Menu
        TriggerServerEvent("nethush-inventory:server:OpenInventory", "stash", "bag_"..QBCore.Functions.GetPlayerData().citizenid)
        TriggerEvent("nethush-inventory:client:SetCurrentStash", "bag_"..QBCore.Functions.GetPlayerData().citizenid)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "stash", 0.5)
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        TriggerEvent("swt_notifications:Infos","Bag succesfully opened.")
    end)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

RegisterNetEvent('nethush-inventory:client:ItemBox')
AddEventHandler('nethush-inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('nethush-inventory:client:busy:status')
AddEventHandler('nethush-inventory:client:busy:status', function(bool)
    CanOpenInventory = bool
end)

RegisterNetEvent('nethush-inventory:client:requiredItems')
AddEventHandler('nethush-inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = QBCore.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('nethush-inventory:server:RobPlayer')
AddEventHandler('nethush-inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(4)
        if Config.HasInventoryOpen then
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        else
            DisableControlAction(0, Config.Keys["TAB"], false)
            DisableControlAction(0, Config.Keys["1"], false)
            DisableControlAction(0, Config.Keys["2"], false)
            DisableControlAction(0, Config.Keys["3"], false)
            DisableControlAction(0, Config.Keys["4"], false)
            DisableControlAction(0, Config.Keys["5"], false)
        end
    end
end)
RegisterNetEvent("nethush-inventory:client:OpenInventory")
AddEventHandler("nethush-inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        		
        QBCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData ~= nil and PlayerData.money ~= nil then
                weedaddiction, cokeaddiction, alcoholaddiction, sodaaddiction, junkfoodaddiction = PlayerData.metadata["lockpickrep"], PlayerData.metadata["hackrep"], PlayerData.metadata["ovrep"], PlayerData.metadata["geduldrep"], PlayerData.metadata["dealerrep"]
            end
        end)
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = Config.MaxInventorySlots,
            other = other,
            maxweight = QBCore.Config.Player.MaxWeight,
            playerhp = GetEntityHealth(PlayerPedId()),
            playerarmor = GetPedArmour(PlayerPedId()),
            weedaddiction = math.floor(weedaddiction),
            cokeaddiction = math.floor(weedaddiction),
            alcoholaddiction = math.floor(alcoholaddiction),
            sodaaddiction = math.floor(sodaaddiction),
            junkfoodaddiction = math.floor(junkfoodaddiction),
        })
        Config.HasInventoryOpen = true
    end
end)

RegisterNetEvent("nethush-inventory:client:UpdatePlayerInventory")
AddEventHandler("nethush-inventory:client:UpdatePlayerInventory", function(isError)
    
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData ~= nil and PlayerData.money ~= nil then
            weedaddiction, cokeaddiction, alcoholaddiction, sodaaddiction, junkfoodaddiction = PlayerData.metadata["lockpickrep"], PlayerData.metadata["hackrep"], PlayerData.metadata["ovrep"], PlayerData.metadata["geduldrep"], PlayerData.metadata["dealerrep"]
        end
    end)
    
    SendNUIMessage({
        action = "update",
        inventory = QBCore.Functions.GetPlayerData().items,
        maxweight = QBCore.Config.Player.MaxWeight,
        slots = Config.MaxInventorySlots,
        playerhp = GetEntityHealth(PlayerPedId()),
        playerarmor = GetPedArmour(PlayerPedId()),
            weedaddiction = weedaddiction,
            cokeaddiction = weedaddiction,
            alcoholaddiction = alcoholaddiction,
            sodaaddiction = sodaaddiction,
            junkfoodaddiction = junkfoodaddiction,
        error = isError,
    })
end)

RegisterNetEvent("nethush-inventory:client:CraftItems")
AddEventHandler("nethush-inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    QBCore.Functions.Progressbar("repair_vehicle", "Crafting...", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("nethush-inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('nethush-inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerEvent("swt_notifications:Infos","Failed!")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("nethush-inventory:client:CraftWeapon")
AddEventHandler("nethush-inventory:client:CraftWeapon", function(itemName, itemCosts, amount, toSlot, ItemType)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    QBCore.Functions.Progressbar("repair_vehicle", "Crafting...", (math.random(10000, 12000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("nethush-inventory:server:CraftWeapon", itemName, itemCosts, amount, toSlot, ItemType)
        TriggerEvent('nethush-inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerEvent("swt_notifications:Infos","Failed!")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("nethush-inventory:client:UseWeapon")
AddEventHandler("nethush-inventory:client:UseWeapon", function(weaponData, shootbool)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerServerEvent('QBCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerServerEvent('QBCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        QBCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent("nethush-inventory:client:CheckWeapon")
AddEventHandler("nethush-inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('nethush-assets:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("nethush-inventory:client:AddDropItem")
AddEventHandler("nethush-inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("nethush-inventory:client:RemoveDropItem")
AddEventHandler("nethush-inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("nethush-inventory:client:DropItemAnim")
AddEventHandler("nethush-inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("nethush-inventory:client:ShowId")
AddEventHandler("nethush-inventory:client:ShowId", function(sourceId, citizenid, character, photo)

    SendNUIMessage({
        action = "close",
    })
    SetNuiFocus(false, false)
    inInventory = false

    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Woman"
        end

        local csn = character.citizenid
        local name = character.firstname
        local name2 = character.lastname
        local birth = character.birthdate
        local gender = gender
        local national = character.nationality
        
        TriggerEvent('virus-idcard:client:open',sourceId, csn, name, name2, birth, gender, national, photo)

    end
end)

RegisterNetEvent("nethush-inventory:client:ShowDriverLicense")
AddEventHandler("nethush-inventory:client:ShowDriverLicense", function(sourceId, citizenid, character, photo)

    SendNUIMessage({
        action = "close",
    })
    SetNuiFocus(false, false)
    inInventory = false

    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then

        local gender = "Man"
        if character.gender == 1 then
            gender = "Woman"
        end

        local csn = character.citizenid
        local name = character.firstname
        local name2 = character.lastname
        local birth = character.birthdate
        local gender = gender
        local national = character.nationality
        
        TriggerEvent('virus-idcard:client:driveropen',sourceId, citizenid, name, name2, birth, gender, national, photo)

        --[[TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Firstname:</strong> {1} <br><strong>Lastname:</strong> {2} <br><strong>Birthdate:</strong> {3} <br><strong>Driver license:</strong> {4}</div></div>',
            args = {'Drivers licenses', character.firstname, character.lastname, character.birthdate, character.type}
        })]]
    end
end)

RegisterNetEvent("nethush-inventory:client:SetCurrentStash")
AddEventHandler("nethush-inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('nethush-inventory:client:open:anim')
AddEventHandler('nethush-inventory:client:open:anim', function()
  exports['nethush-assets']:RequestAnimationDict('pickup_object')
  TaskPlayAnim(PlayerPedId(), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
  Citizen.Wait(1000)
  ClearPedSecondaryTask(PlayerPedId())
end)


-- // Functions \\ --

function ClosestContainer()
    for k, v in pairs(Config.Dumpsters) do
        local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
          BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
         local EntityHitCoords = GetEntityCoords(EntityHit)
         if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
             EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
         end
         return EntityHitCoords
        end
    end
end

function ClosestJailContainer()
  for k, v in pairs(Config.JailContainers) do
      local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
      local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
      local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
      local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
      local BinModel = 0
      if EntityHit then
        BinModel = GetEntityModel(EntityHit)
      end
      if v['Model'] == BinModel then
       local EntityHitCoords = GetEntityCoords(EntityHit)
       if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
           EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
       end
       return EntityHitCoords
      end
  end
end

function OpenTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
 local HotbarItems = {
  [1] = QBCore.Functions.GetPlayerData().items[1],
  [2] = QBCore.Functions.GetPlayerData().items[2],
  [3] = QBCore.Functions.GetPlayerData().items[3],
  [4] = QBCore.Functions.GetPlayerData().items[4],
  [5] = QBCore.Functions.GetPlayerData().items[5],
 } 
 if toggle then
     SendNUIMessage({
         action = "toggleHotbar",
         open = true,
         items = HotbarItems
     })
 else
     SendNUIMessage({
         action = "toggleHotbar",
         open = false,
     })
 end
end

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if Config.WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(Config.WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end