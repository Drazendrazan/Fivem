
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 
--- CODEM STORE  https://discord.gg/YZMZsv4yCy ---- 


QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)



RegisterServerEvent("nethush-house:Pay")
AddEventHandler("nethush-house:Pay", function()
	local src = source
	  local Player = QBCore.Functions.GetPlayer(src)
	  local price = 25000
    Player.Functions.AddMoney("bank", price, "sold-pawn-items")

end)





