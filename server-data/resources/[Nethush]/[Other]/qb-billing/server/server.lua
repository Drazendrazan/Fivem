QBCore = nil

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)

QBCore.Commands.Add("bill", "Create a bill to send to another player", {{name="id", help="Player ID"},{name="ammount", help="Value of the bill"},{name="reason", help="Reason for the bill"}}, false, function(source, args)
    Player = QBCore.Functions.GetPlayer(source)
    OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player ~= nil then
        if OtherPlayer ~= nil then
            name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
            playerId = tonumber(args[1])
            price = tonumber(args[2])
            citizenid = Player.PlayerData.citizenid
            
            table.remove(args, 1)
            table.remove(args, 1)
            local reason = table.concat(args, " ")


            TriggerClientEvent("qb-billing:client:sendBillingMail", playerId, name, price, reason,citizenid)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online")
        end
    end
end)

RegisterNetEvent('qb-billing:server:PayBill')
AddEventHandler('qb-billing:server:PayBill',function(data)
    Player = QBCore.Functions.GetPlayer(source)
    OtherPlayer = QBCore.Functions.GetPlayerByCitizenId(data[2])
    if Player ~= nil then
       Balance = Player.PlayerData.money["bank"]
       
       if Balance - data[1] >= 0 then
            Player.Functions.RemoveMoney("bank",data[1],"paid-bill")
            if OtherPlayer ~= nil then
                OtherPlayer.Functions.AddMoney("bank",data[1],"recieved-bill")
                TriggerClientEvent("swt_notifications:Infos",OtherPlayer.PlayerData.source, "You recieved $"..data[1].." from "..Player.PlayerData.charinfo.firstname.. " ".. Player.PlayerData.charinfo.lastname )
            end
       end
    end
end)
