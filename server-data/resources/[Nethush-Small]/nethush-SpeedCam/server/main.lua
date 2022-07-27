
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


RegisterServerEvent('esx_speedcamera:PayBill60Zone')
AddEventHandler('esx_speedcamera:PayBill60Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 500
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
	--TriggerClientEvent('police:client:sendBillingMail', source, totalAmount)
	--TriggerEvent('cash-playersafes:server:DepositMoney', "police", totalAmount, "bills")
end)

RegisterServerEvent('esx_speedcamera:PayBill80Zone')
AddEventHandler('esx_speedcamera:PayBill80Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 1000
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
	--TriggerClientEvent('police:client:sendBillingMail', source, totalAmount)
	--TriggerEvent('cash-playersafes:server:DepositMoney', "police", totalAmount, "bills")
end)

RegisterServerEvent('esx_speedcamera:PayBill120Zone')
AddEventHandler('esx_speedcamera:PayBill120Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 2000
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
	--TriggerClientEvent('police:client:sendBillingMail', source, totalAmount)
	--TriggerEvent('cash-playersafes:server:DepositMoney', "police", totalAmount, "bills")
end)

-- BILLS WITHOUT ESX_BILLING (END)

-- FLASHING EFFECT (START)

RegisterServerEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
	TriggerClientEvent('esx_speedcamera:openGUI', source)
end)

RegisterServerEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
	TriggerClientEvent('esx_speedcamera:closeGUI', source)
end)

-- FLASHING EFFECT (END)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end