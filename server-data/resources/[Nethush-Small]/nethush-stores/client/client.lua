local NearShop = false
local isLoggedIn = true
local CurrentShop = nil

QBCore = nil

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    

   
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
   TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
    Citizen.Wait(250)
    QBCore.Functions.TriggerCallback("nethush-stores:server:GetConfig", function(config)
      Config = config
    end)
   isLoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.5 then
                    NearShop = true
                    CurrentShop = k
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        end
    end
end)

RegisterNetEvent('nethush-stores:server:open:shop')
AddEventHandler('nethush-stores:server:open:shop', function()
  Citizen.SetTimeout(350, function()
      if CurrentShop ~= nil then 
        local Shop = {label = Config.Shops[CurrentShop]['Name'], items = Config.Shops[CurrentShop]['Product'], slots = 30}
        TriggerServerEvent("nethush-inventory:server:OpenInventory", "shop", "Itemshop_"..CurrentShop, Shop)
      end
  end)
end)

RegisterNetEvent('nethush-stores:client:update:store')
AddEventHandler('nethush-stores:client:update:store', function(ItemData, Amount)
    TriggerServerEvent('nethush-stores:server:update:store:items', CurrentShop, ItemData, Amount)
end)

RegisterNetEvent('nethush-stores:client:set:store:items')
AddEventHandler('nethush-stores:client:set:store:items', function(ItemData, Amount, ShopId)
    Config.Shops[ShopId]["Product"][ItemData.slot].amount = Config.Shops[ShopId]["Product"][ItemData.slot].amount - Amount
end)

RegisterNetEvent('nethush-stores:client:open:custom:store')
AddEventHandler('nethush-stores:client:open:custom:store', function(ProductName)
    local Shop = {label = ProductName, items = Config.Products[ProductName], slots = 30}
    TriggerServerEvent("nethush-inventory:server:OpenInventory", "shop", "custom", Shop)
end)

-- // Function \\ --

function IsNearShop()
    return NearShop
end