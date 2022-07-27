--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw

) Change QBCore to your CORE if renamed

) Copy and replace below code with yours



-------------------------------------------
-------------------------------------------
client.lua
-------------------------------------------
-------------------------------------------
1. ID CARD 

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

        --[[TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>Firstname:</strong> {2} <br><strong>Lastname:</strong> {3} <br><strong>Birthdate:</strong> {4} <br><strong>Gender:</strong> {5} <br><strong>Country:</strong> {6}</div></div>',
            args = {'ID-Card', character.citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })]]
    end
end)

-------------------------------------------

2. Driving License 

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


-------------------------------------------
-------------------------------------------
server.lua
-------------------------------------------
-------------------------------------------


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

--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw
--DEVELOPED BY VIRUS, DISCORD : https://dsc.gg/virusfw