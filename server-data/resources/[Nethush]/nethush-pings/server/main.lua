QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local Pings = {}

QBCore.Commands.Add("ping", "", {{name = "action", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('nethush-pings:client:AcceptPing', src, Pings[src], QBCore.Functions.GetPlayer(Pings[src].sender))
                TriggerClientEvent('swt_notifications:Infos', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('swt_notifications:Infos', src, "You don't have a ping open..")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('swt_notifications:Infos', Pings[src].sender, "Your ping has been rejected..")
                TriggerClientEvent('swt_notifications:Infos', src, "Tiy rejected the ping..")
                Pings[src] = nil
            else
                TriggerClientEvent('swt_notifications:Infos', src, "You don't have a ping open..")
            end
        else
            TriggerClientEvent('nethush-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('swt_notifications:Infos', src, "You don't have a phone..")
    end
end)

RegisterServerEvent('nethush-pings:server:SendPing')
AddEventHandler('nethush-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('swt_notifications:Infos', src, "You sent a ping to "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                }
                TriggerClientEvent('swt_notifications:Infos', id, "You recived a ping from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('swt_notifications:Infos', src, "Could not send the ping, person may dont have a phone.")
            end
        else
            TriggerClientEvent('swt_notifications:Infos', src, "This person is not online..")
        end
    else
        TriggerClientEvent('swt_notifications:Infos', src, "You dont have a phone")
    end
end)

RegisterServerEvent('nethush-pings:server:SendLocation')
AddEventHandler('nethush-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('nethush-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)