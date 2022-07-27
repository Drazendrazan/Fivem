QBCore = nil 

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)




QBCore.Functions.CreateCallback('nethush_carDelivery:getStorage', function(source, cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	
	
	MySQL.Async.fetchAll('SELECT * FROM nethush_carDelivery ORDER BY price ASC', {}, function(result)
		cb(json.encode(result))

		
		
		
	end)
end)

QBCore.Functions.CreateCallback('nethush_carDelivery:getCount', function(source, cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	local countPlayer = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM nethush_carDelivery")
	print(countPlayer)
	
	cb(countPlayer)
end)



QBCore.Functions.CreateCallback('nethush_carDelivery:spawnVehicle', function(source, cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	
	cb()
end)



RegisterNetEvent("nethush_carDelivery:payout")
AddEventHandler("nethush_carDelivery:payout", function(payout)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.AddMoney("bank", payout, "Cardealivery")


end)






RegisterNetEvent("nethush_carDelivery:addVehicles")
AddEventHandler("nethush_carDelivery:addVehicles", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)

	for i= 1, 4 do

		Citizen.Wait(500)

		local name = math.random(1, Config.maxNameNumber)
		local vehType = math.random(1, Config.maxVehTypeNumber)
		local price = math.random(Config.MinRangePrice, Config.MaxRangePrice)
	
	
		
		
		
	
		MySQL.Async.execute('INSERT INTO nethush_carDelivery (name, type, price) VALUES (@name, @type, @price)',
		{ ['name'] = Config.Names[name], ['type'] =  Config.vehType[vehType], ['price'] = price},
		function()
		  
		end)
	end

	



end)





RegisterServerEvent('nethush_carDelivery:startDeliveryJob')
AddEventHandler('nethush_carDelivery:startDeliveryJob', function(idItemBuy)
    
	local b = source;
    local c = QBCore.Functions.GetPlayer(b)
	local xPlayer = QBCore.Functions.GetPlayer(source)


	
	

	MySQL.Async.fetchAll('SELECT * FROM nethush_carDelivery WHERE id = @idItemBuy',
		  { ['idItemBuy'] = idItemBuy },
		  function(result)
			

		TriggerClientEvent("nethush_carDelivery:startJobDeliverySpawn", b, result[1].name, result[1].type, result[1].price)

		MySQL.Async.execute('DELETE FROM nethush_carDelivery WHERE `id` = @id', {['@id'] = result[1].id})
				
				
		print("JOB Started")
						
		
				
				
				
				


	end)

	
	
	
end)

