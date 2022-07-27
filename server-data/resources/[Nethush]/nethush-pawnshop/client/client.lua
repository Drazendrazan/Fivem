LoggedIn = false

QBCore = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(750, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end) 
     Citizen.Wait(150)   
     LoggedIn = true
    end)
end)