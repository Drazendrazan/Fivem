QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code
QBCore.Functions.CreateUseableItem("ecola", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink', source, 'ecola', 'cola')
    end
end)

QBCore.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink', source, 'sprunk', 'cola')
    end
end)

QBCore.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:slushy', source)
    end
end)

QBCore.Functions.CreateUseableItem("drill", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:drill', source)
    end
end)

QBCore.Functions.CreateUseableItem("chocolade", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'chocolade', 'chocolade')
    end
end)

QBCore.Functions.CreateUseableItem("420-choco", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, '420-choco', 'chocolade')
    end
end)

QBCore.Functions.CreateUseableItem("donut", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'donut', 'donut')
    end
end)

QBCore.Functions.CreateUseableItem("coffee", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink', source, 'coffee', 'coffee')
    end
end)

QBCore.Functions.CreateUseableItem("glasswhiskey", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'glasswhiskey', 'glasswhiskey')
    end
end)

QBCore.Functions.CreateUseableItem("glasswine", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'glasswine', 'glasswine')
    end
end)

QBCore.Functions.CreateUseableItem("glassbeer", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'glassbeer', 'glassbeer')
    end
end)

QBCore.Functions.CreateUseableItem("bloodymary", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'bloodymary', 'bloodymary')
    end
end)

QBCore.Functions.CreateUseableItem("champagne", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'champagne', 'champagne')
    end
end)

QBCore.Functions.CreateUseableItem("glasschampagne", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'glasschampagne', 'glasschampagne')
    end
end)

QBCore.Functions.CreateUseableItem("dusche", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'dusche', 'dusche')
    end
end)

QBCore.Functions.CreateUseableItem("tequila", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'tequila', 'tequila')
    end
end)

QBCore.Functions.CreateUseableItem("tequilashot", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'tequilashot', 'tequilashot')
    end
end)

QBCore.Functions.CreateUseableItem("whitewine", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'whitewine', 'whitewine')
    end
end)

QBCore.Functions.CreateUseableItem("pinacolada", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink:alcohol', source, 'pinacolada', 'pinacolada')
    end
end)

-- BurgerShot

QBCore.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'burger-bleeder', 'hamburger')
    end
end)

QBCore.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'burger-moneyshot', 'hamburger')
    end
end)

QBCore.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'burger-torpedo', 'hamburger')
    end
end)

QBCore.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'burger-heartstopper', 'hamburger')
    end
end)

QBCore.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink', source, 'burger-softdrink', 'burger-soft')
    end
end)

QBCore.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:eat', source, 'burger-fries', 'burger-fries')
    end
end)

QBCore.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-burgershot:client:open:box', source, item.info.boxid)
    end
end)

QBCore.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:drink', source, 'burger-coffee', 'coffee')
    end
end)
-- // Other \\ --

QBCore.Functions.CreateUseableItem("duffel-bag", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:duffel-bag', source, item.info.bagid)
    end
end)

QBCore.Functions.CreateUseableItem("spikestrip", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('qb-police:client:SpawnSpikeStrip', source)
    end
end)

QBCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:lockpick', source, true)
    end
end)

QBCore.Functions.CreateUseableItem("bag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("nethush-inventory:bag:UseBag", source)
    TriggerEvent("qb-log:server:CreateLog", "nethush-inventory", "Bags", "white", "Player opened a bag **"..GetPlayerName(source).."** Citizen ID: **"..Player.PlayerData.citizenid.. "**", false)
end)



QBCore.Functions.CreateUseableItem("health-pack", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-hospital:client:use:health-pack', source)
    end
end)

-- Weed

QBCore.Functions.CreateUseableItem("white-widow-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'White Widow', 'White-Widow', 'white-widow-seed')
    end
end)

QBCore.Functions.CreateUseableItem("skunk-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'Skunk', 'Skunk', 'skunk-seed')
    end
end)

QBCore.Functions.CreateUseableItem("purple-haze-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'Purple Haze', 'Purple-Haze', 'purple-haze-seed')
    end
end)

QBCore.Functions.CreateUseableItem("og-kush-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'Og Kush', 'Og-Kush', 'og-kush-seed')
    end
end)

QBCore.Functions.CreateUseableItem("amnesia-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'Amnesia', 'Amnesia', 'amnesia-seed')
    end
end)

QBCore.Functions.CreateUseableItem("ak47-seed", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-houseplants:client:plant', source, 'AK47', 'AK47', 'ak47-seed')
    end
end)

QBCore.Functions.CreateUseableItem("oxy", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:oxy', source)
    end
end)

QBCore.Functions.CreateUseableItem("key-a", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-illegal:client:use:key', source, 'key-a')
    end
end)

QBCore.Functions.CreateUseableItem("key-b", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-illegal:client:use:key', source, 'key-b')
    end
end)
QBCore.Functions.CreateUseableItem("packed-coke-brick", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-illegal:client:unpack:coke', source)
    end
end)
QBCore.Functions.CreateUseableItem("burner-phone", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-illegal:client:start:burner-call', source)
    end
end)

QBCore.Functions.CreateUseableItem("key-c", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-illegal:client:use:key', source, 'key-c')
    end
end)

QBCore.Functions.CreateUseableItem("coke-bag", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:coke', source)
    end
end)

QBCore.Functions.CreateUseableItem("lsd-strip", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("nethush-items:client:use:lsd", source)
    end
end)

QBCore.Functions.CreateUseableItem("meth-bag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("nethush-items:client:use:meth", source)
end)

QBCore.Functions.CreateUseableItem("coin", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:coinflip', source)
    end
end)

QBCore.Commands.Add("dice", "Play some dice!", {{name="amount", help="Amounts of dices"}, {name="zijdes", help="How many sides?"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local DiceItems = Player.Functions.GetItemByName("dice")
    if args[1] ~= nil and args[2] ~= nil then 
      local Amount = tonumber(args[1])
      local Sides = tonumber(args[2])
      if DiceItems ~= nil then
         if (Sides > 0 and Sides <= 20) and (Amount > 0 and Amount <= 5) then 
             TriggerClientEvent('nethush-items:client:dobbel', source, Amount, Sides)
         else
             TriggerClientEvent('swt_notifications:Infos', source, "To many dices 0 (max: 5) or too many sides 0 (max: 20)")
         end
      else
        TriggerClientEvent('swt_notifications:Infos', source, "You dont have any dices..")
      end
  end
end)

QBCore.Functions.CreateUseableItem("ciggy", function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('nethush-items:client:use:cigarette', source, true)
    end
end)

QBCore.Commands.Add("armoroff", "Take of your armor", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("nethush-items:client:reset:armor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency personal")
    end
end)