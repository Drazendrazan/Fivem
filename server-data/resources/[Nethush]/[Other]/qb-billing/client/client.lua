QBCore = nil

local data = {}

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('qb-billing:client:sendBillingMail')
AddEventHandler('qb-billing:client:sendBillingMail',function(name,price,reason,citizenid)
    table.insert(data,price)
    table.insert(data,citizenid)
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = name,
        subject = "Bill",
        message = "You have been sent a bill for, <br>Amount: <br> $"..price.." for "..reason.."<br><br> press the button below to accept the bill",
        button = {
            enabled = true,
            buttonEvent = "qb-billing:client:AcceptBill",
            buttonData = data
        }
    })
    data = {}
end)

RegisterNetEvent('qb-billing:client:AcceptBill')
AddEventHandler('qb-billing:client:AcceptBill',function(data)
    TriggerEvent("swt_notifications:Infos","You paid the bill")
    
    TriggerServerEvent('qb-billing:server:PayBill',data)
end)