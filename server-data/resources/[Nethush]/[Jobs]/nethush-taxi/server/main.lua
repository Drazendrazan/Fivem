QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code


QBCore.Functions.CreateCallback('qb-taxi:server:NpcPay', function(source, cb, Payment)
	local fooi = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooi == r1 or fooi == r2 then
        Payment = Payment + math.random(5, 10)
    end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment)
end)

RegisterServerEvent('qb-taxi:server:NpcPay')
AddEventHandler('qb-taxi:server:NpcPay', function(Payment)
end)