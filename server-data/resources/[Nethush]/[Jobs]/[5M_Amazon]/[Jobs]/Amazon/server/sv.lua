QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--base

	
RegisterServerEvent('Amazon:cash')
AddEventHandler('Amazon:cash', function(currentJobPay)
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
	local currentJobPay = math.random(3000,5000)
    xPlayer.Functions.AddMoney("cash", currentJobPay)
	TriggerClientEvent("swt_notifications:Icon",_source,'You earned Dollers',"top-right",5500,"blue-10","white",true,"mdi-earth")
end)	