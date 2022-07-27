QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
}



RegisterServerEvent('qb-admin:server:togglePlayerNoclip')
AddEventHandler('qb-admin:server:togglePlayerNoclip', function(playerId, reason)
end)

RegisterServerEvent('qb-admin:server:killPlayer')
AddEventHandler('qb-admin:server:killPlayer', function(playerId)
end)

RegisterServerEvent('qb-admin:server:kickPlayer')
AddEventHandler('qb-admin:server:kickPlayer', function(playerId, reason)
end)

RegisterServerEvent('qb-admin:server:Freeze')
AddEventHandler('qb-admin:server:Freeze', function(playerId, toggle)
end)

RegisterServerEvent('qb-admin:server:serverKick')
AddEventHandler('qb-admin:server:serverKick', function(reason)
end)

local suffix = {
    "- All",
    "- All",
    "- Goodbye friends",
    "- Yeet Back to ESX",
}

RegisterServerEvent('qb-admin:server:banPlayer')
AddEventHandler('qb-admin:server:banPlayer', function(playerId, time, reason)
end)

RegisterServerEvent('qb-admin:server:revivePlayer')
AddEventHandler('qb-admin:server:revivePlayer', function(target)
end)

QBCore.Commands.Add("announce", "Send a message to everyone", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

QBCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = QBCore.Functions.GetPermission(source)
    -- local dealers = exports['qb-drugs']:GetDealers()
    TriggerClientEvent('qb-admin:client:openMenu', source, group)
end, "admin")

QBCore.Commands.Add("bring", "Teleport a player to you", {{name="id", help="ID of a player"}}, false, function(source, args)
    if args[1] ~= nil then
        -- tp player to you
        local src = source
        local Admin = QBCore.Functions.GetPlayer(src)
        local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
        if Player ~= nil then
            TriggerClientEvent('QBCore:Command:TeleportToPlayer', Player.PlayerData.source, Admin.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
        end
    end
end, "admin")

QBCore.Commands.Add("report", "Send a report to admins (only if necessary, DO NOT ABUSE THIS)", {{name="message", help="message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT SENT", "normal", msg)
    TriggerEvent("qb-log:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

QBCore.Commands.Add("staffchat", "message to all staff", {{name="message", help="message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

QBCore.Commands.Add("givenuifocus", "Give nui focus", {{name="id", help="Player id"}, {name="focus", help="Turn focus on / off"}, {name="mouse", help="Turn mouse on / off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('qb-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

QBCore.Commands.Add("s", "Send message to all staff", {{name="message", help="Message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

QBCore.Commands.Add("noclip", "noclip", {}, false, function(source, args)
    if QBCore.Functions.HasPermission(source, permissions["noclip"]) then
        TriggerClientEvent("qb-admin:client:toggleNoclip", source)
    end
end, "admin")

QBCore.Commands.Add("kick", "kick a player", {{name = "id", help = "Player ID"}}, false, function(source, args)
    local reason = table.concat(args, ' ')
    if QBCore.Functions.HasPermission(source, permissions["kick"]) then
        DropPlayer(args[1], "You have been kicked from the server:\n"..reason.."\n\n")
    end
end, "admin")

QBCore.Commands.Add("warn", "Give a person a warning", {{name="ID", help="Person"}, {name="Reason", help="Enter a reason"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = QBCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "You have been warned by: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You have "..GetPlayerName(targetPlayer.PlayerData.source).." be warned against: "..msg)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('swt_notifications:Infos', source, 'Message you want to send '..myName..' and i stink loloololo')
    end 
end, "admin")

QBCore.Commands.Add("givewarn", "Give a person a warning", {{name="ID", help="Person"}, {name="Warning", help="Number of warning, (1, 2 of 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." has "..tablelength(result).." warnings!")
        end)
    else
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." has been warned by "..sender.PlayerData.name..", Reason: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

QBCore.Commands.Add("removewarn", "Remove warning from person", {{name="ID", help="Person"}, {name="Warning", help="Number of warning, (1, 2 of 3 etc..)"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "You have warning ("..selectedWarning..") deleted, Reason: "..warnings[selectedWarning].reason)
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "god")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

QBCore.Commands.Add("reportr", "Reply op een report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local Player = QBCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('swt_notifications:Infos', source, "Response sent")
        TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            if QBCore.Functions.HasPermission(v, "admin") then
                if QBCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("qb-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** responded to: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('swt_notifications:Infos', source, "Person is not online")
    end
end, "admin")

QBCore.Commands.Add("setmodel", "Change to a model of your choice..", {{name="model", help="Name of the model"}, {name="id", help="Player ID (leave blank for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('qb-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = QBCore.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('qb-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('swt_notifications:Infos', source, "This person is not in town yeet..")
            end
        end
    else
        TriggerClientEvent('swt_notifications:Infos', source, "You have not specified a Model..")
    end
end, "god")

QBCore.Commands.Add("setspeed", "You have not specified a Model", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('qb-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('swt_notifications:Infos', source, "You have not specified a Speed.. (`fast` in front of super-run, `normal` for normall)")
    end
end, "god")


QBCore.Commands.Add("admincar", "Place vehicle in your garage", {}, false, function(source, args)
    local ply = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SaveCar', source)
end, "god")

RegisterServerEvent('qb-admin:server:SaveCar')
AddEventHandler('qb-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    
end)

QBCore.Commands.Add("reporttoggle", "Toggle incoming reports from or to", {}, false, function(source, args)
    QBCore.Functions.ToggleOptin(source)
    if QBCore.Functions.IsOptin(source) then
        TriggerClientEvent('swt_notifications:Infos', source, "You DO get reports")
    else
        TriggerClientEvent('swt_notifications:Infos', source, "You get NO reports")
    end
end, "admin")

QBCore.Commands.Add("cleararea", "remove peds, vehicles and everything in the area", {}, false, function(source, args)
    TriggerClientEvent('QBCore:ClearArea', -1)
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = QBCore.Functions.GetPlayer(src)

        if QBCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(QBCore.Functions.GetPlayers()) do
                    local Player = QBCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Please provide a reason..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'You cant just do this baby..')
        end
    else
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Server restart, see discord for more information! (discord.gg/xxxxx)")
            end
        end
    end
end, false)

RegisterServerEvent('qb-admin:server:bringTp')
AddEventHandler('qb-admin:server:bringTp', function(targetId, coords)
end)

RegisterServerEvent('qb-admin:server:setPermissions')
AddEventHandler('qb-admin:server:setPermissions', function()
end)

RegisterServerEvent('qb-admin:server:OpenSkinMenu')
AddEventHandler('qb-admin:server:OpenSkinMenu', function(targetId)
end)

RegisterServerEvent('qb-admin:server:SendReport')
AddEventHandler('qb-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "admin") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('qb-admin:server:StaffChatMessage')
AddEventHandler('qb-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "admin") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)


QBCore.Functions.CreateCallback('qb-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if QBCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('qb-admin:server:getTargetAppartment', function(source, cb, player)
    local Target = QBCore.Functions.GetPlayer(player)
    
    local appartment = Target.PlayerData.metadata["currentapartment"]

    cb(appartment)
end)

QBCore.Functions.CreateCallback('qb-admin:server:getTargetData', function(source, cb, player)
    local Target = QBCore.Functions.GetPlayer(player)
    local bsn = Target.PlayerData.citizenid
    local fname = Target.PlayerData.charinfo.firstname
    local lname = Target.PlayerData.charinfo.lastname

    cb(bsn, fname, lname)
end)

QBCore.Functions.CreateCallback('qb-admin:setPermissions', function(source, cb, targetId, group)
    QBCore.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('swt_notifications:Infos', targetId, 'Your permission group has been set to '..group.label)
end)

QBCore.Functions.CreateCallback('qb-admin:server:togglePlayerNoclip', function(source, cb, playerId, reason)
	local src = source
    if QBCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("qb-admin:client:toggleNoclip", playerId)
    end
end)

QBCore.Functions.CreateCallback('qb-admin:server:killPlayer', function(source, cb, playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)

end)

QBCore.Functions.CreateCallback('qb-admin:server:kickPlayer', function(source, cb, playerId, reason)
	local src = source
    if QBCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "You have been kicked from the server:\n"..reason.."\n\n🔸 Check out our discord for more information: https://discord.gg/xxxxxx")
    end
end)

QBCore.Functions.CreateCallback('qb-admin:server:Freeze', function(source, cb, playerId, toggle)
    TriggerClientEvent('qb-admin:client:Freeze', playerId, toggle)
end)

QBCore.Functions.CreateCallback('qb-admin:server:serverKick', function(source, cb, reason)
	local src = source
    if QBCore.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "You have been kicked from the server:\n"..reason.."\n\n🔸 Check out our discord for more information: https://discord.gg/xxxxxx")
            end
        end
    end
end)

QBCore.Functions.CreateCallback('qb-admin:server:banPlayer', function(source, cb, playerId, time, reason)
	local src = source
    if QBCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        --TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." is verbannen voor: "..reason.." "..suffix[math.random(1, #suffix)])
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "You have been banned from the server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Check out our discord for more information")
    end
end)

QBCore.Functions.CreateCallback('qb-admin:server:revivePlayer', function(source, cb, target)
	TriggerClientEvent('hospital:client:Revive', target)
end)

QBCore.Functions.CreateCallback('qb-admin:server:bringTp', function(source, cb, targetId, coords)
    TriggerClientEvent('qb-admin:client:bringTp', targetId, coords)
end)

QBCore.Functions.CreateCallback('qb-admin:server:OpenSkinMenu', function(source, cb, targetId)
    TriggerClientEvent("qb-clothing:client:openMenu", targetId)
	
end)

QBCore.Functions.CreateCallback('qb-admin:server:SaveCar', function(source, cb, mods, vehicle, hash, plate)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('swt_notifications:Infos', src, 'The vehicle is now in your name!')
        else
            TriggerClientEvent('swt_notifications:Infos', src, 'This vehicle is already in your garage..', 'error', 3000)
        end
    end)
end)

QBCore.Commands.Add("setammo", "Staff: Set manual ammo for a weapon.", {{name="amount", help="Amount of bullets, for example: 20"}, {name="weapon", help="Name of the weapen, for example: WEAPON_VINTAGEPISTOL"}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, "current", amount)
    end
end, 'admin')