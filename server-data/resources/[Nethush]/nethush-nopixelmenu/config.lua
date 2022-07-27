local DutyVehicles = {}
HasHandCuffs = false

Config = Config or {}

Config.Keys = {["F2"] = 289}

Config.Menu = {
 [1] = {
    id = "animations",
    displayName = "Walkstyle",
    icon = "#walking",
    enableMenu = function()
    --   if not exports['hospital']:GetDeathStatus() then
           return true
    --    end
    end,
    subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
 },
 [2] = {
     id = "expressions",
     displayName = "Facial Expressions",
     icon = "#expressions",
     enableMenu = function()
       --  if not exports['hospital']:GetDeathStatus() then
            return true
       --  end
     end,
     subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
 },
 [3] = {
    id = "shop",
    displayName = "Shop",
    icon = "#global-store",
    close = true,
    functiontype = "client",
    functionName = "nethush-stores:server:open:shop",
    enableMenu = function()
     --   if not exports['hospital']:GetDeathStatus() then
            if exports['nethush-stores']:IsNearShop() then
                return true
            end
     --   end
  end,
 },
 [4] = {
    id = "scrapyard",
    displayName = "Scrap Vehicle",
    icon = "#police-action-vehicle-spawn",
    close = true,
    functiontype = "client",
    functionName = "nethush-materials:client:scrap:vehicle",
    enableMenu = function()
     --   if not exports['hospital']:GetDeathStatus() then
          if exports['nethush-materials']:IsNearScrapYard() then
            return true
          end
    --    end
  end,
 },
 [5] = {
    id = "trash",
    displayName = "Search Bin",
    icon = "#global-trash",
    close = true,
    functiontype = "client",
    functionName = "nethush-materials:client:search:trash",
    enableMenu = function()
   --     if not exports['hospital']:GetDeathStatus() then
          if exports['nethush-materials']:GetBinStatus() then
            return true
          end
   --     end
  end,
 },
  [6] = {
    id = "cityhall",
    displayName = "Cityhall",
    icon = "#global-cityhall",
    close = true,
    functiontype = "client",
    functionName = "qb-cityhall:client:open:nui",
    enableMenu = function()
    --    if not exports['hospital']:GetDeathStatus() then
            if exports['qb-cityhall']:CanOpenCityHall() then
                return true
            end
   --     end
  end,
 },
 [7] = {
    id = "dealer",
    displayName = "Dealer Shop",
    icon = "#global-dealer",
    close = true,
    functiontype = "client",
    functionName = "nethush-dealers:client:open:dealer",
    enableMenu = function()
       -- if not exports['hospital']:GetDeathStatus() then
            if exports['nethush-dealers']:CanOpenDealerShop() then
                return true
            end
      --  end
  end,
 },
 [8] = {
    id = "citizen",
    displayName = "Citizen",
    icon = "#citizen-action",
    enableMenu = function()
       -- if not exports['nethush-hospital']:GetDeathStatus() then
            return true
      --  end
    end,
    subMenus = {"citizen:escort", 'citizen:steal', 'citizen:contact', 'citizen:vehicle:getout', 'citizen:vehicle:getin', 'citizen:corner:selling'}
 },
 [9] = {
    id = "garage",
    displayName = "Garage",
    icon = "#citizen-action-garage",
    enableMenu = function()
      --  if not exports['qb-hospital']:GetDeathStatus() then
            if exports['nethush-garages']:IsNearGarage() then
                return true
            end
      --  end
    end,
    subMenus = {"garage:putin", "garage:getout"}
 },
 [10] = {
  id = "depot",
  displayName = "Depot",
  icon = "#global-depot",
  close = true,
  functiontype = "client",
  functionParameters = false,
  functionName = "nethush-garages:client:open:depot",
  enableMenu = function()
    --  if not exports['qb-hospital']:GetDeathStatus() then
          if exports['nethush-garages']:IsNearDepot() then
              return true
          end
     -- end
end,
},
}

Config.SubMenus = {
    ['police:checkstatus'] = {
        title = "Status",
        icon = "#police-action-search",
        close = true,
        functiontype = "client",
        functionName = "police:client:CheckStatus"
       },
       ['police:panic'] = {
           title = "Emergency",
           icon = "#police-action-panic",
           close = true,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:send:panic:button"
          },
       ['police:tablet'] = {
        title = "MEOS Tablet",
        icon = "#police-action-tablet",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:show:tablet"
       },
       ['police:impound'] = {
       title = "Remove Vehicle",
       icon = "#police-action-vehicle",
       close = true,
       functiontype = "client",
       functionName = "nethush-police:client:impound:closest"
       },
       ['police:impoundhard'] = {
       title = "Impound",
       icon = "#police-action-vehicle",
       close = true,
       functiontype = "client",
       functionName = "nethush-police:client:impound:hard:closest"
       },
       ['police:search'] = {
        title = "Search",
        icon = "#police-action-search",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:search:closest"
       },
       ['police:resetdoor'] = {
        title = "Reset House Door",
        icon = "#global-appartment",
        close = true,
        functiontype = "client",
        functionName = "nethush-housing:client:reset:house:door"
       },
       ['police:enkelband'] = {
        title = "Location",
        icon = "#police-action-enkelband",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:enkelband:closest"
       },
       ['police:badge'] = {
           title = "Show Badge",
           icon = "#police-action-tablet",
           close = true,
           functiontype = "client",
           functionName = "nethush-badge:openPD"
       },
       ['police:vehicle:touran'] = {
        title = "Ford Tauros",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'code3fpis',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:klasse'] = {
        title = "Ford Crown Vic",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'code3cvpi',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:vito'] = {
        title = "Chevy Tahoe '14",
        icon = "#police-action-vehicle-spawn-bus",
        close = true,
        functionParameters = 'code314tahoe',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:charger'] = {
           title = "Dodge Charger '18",
           icon = "#police-action-vehicle-spawn-bus",
           close = true,
           functionParameters = 'code318charg',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:audi'] = {
        title = "Ford Explorer",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'code316fpiu',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:velar'] = {
        title = "Ford Expedition",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'code320exp',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:unmaked:audi'] = {
           title = "Ford Mustang GT",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'code3mustang',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:bmw'] = {
        title = "Ford Mustang GT",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'code3mustang',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:heli'] = {
        title = "G-POLA Helicopter",
        icon = "#police-action-vehicle-spawn-heli",
        close = true,
        functionParameters = 'polmav',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:motor'] = {
        title = "Harley Bike",
        icon = "#police-action-vehicle-spawn-motor",
        close = true,
        functionParameters = 'code3harley',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:motor2'] = {
           title = "BMW Bike",
           icon = "#police-action-vehicle-spawn-motor",
           close = true,
           functionParameters = 'code3bmw',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valorfpiu'] = {
           title = "Sheriff FPIU",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor20fpiu',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valorcharger'] = {
           title = "Sheriff '18 Charger",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor18charg',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valor18tahoe'] = {
           title = "Sheriff '18 Tahoe",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor18tahoe',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valor18tahoe'] = {
           title = "Sheriff '18 Tahoe",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor18tahoe',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valorsilv'] = {
           title = "Sheriff Silverado",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor19silv',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valorcvpi'] = {
           title = "Sheriff Crown Vic",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valorcvpi',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valor13tahoe'] = {
           title = "Sheriff '13 Tahoe",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor13tahoe',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:vehicle:valor14charg'] = {
           title = "Sheriff '14 Charger",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = 'valor14charg',
           functiontype = "client",
           functionName = "nethush-police:client:spawn:vehicle"
       },
       ['police:object:cone'] = {
        title = "Cone",
        icon = "#global-box",
        close = true,
        functionParameters = 'cone',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:object"
       },
       ['police:object:barrier'] = {
        title = "Barrier",
        icon = "#global-box",
        close = true,
        functionParameters = 'barrier',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:object"
       },
       ['police:object:schot'] = {
        title = "Fence",
        icon = "#global-box",
        close = true,
        functionParameters = 'schot',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:object"
       },
       ['police:object:tent'] = {
        title = "Tent",
        icon = "#global-tent",
        close = true,
        functionParameters = 'tent',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:object"
       },
       ['police:object:light'] = {
        title = "Light",
        icon = "#global-box",
        close = true,
        functionParameters = 'light',
        functiontype = "client",
        functionName = "nethush-police:client:spawn:object"
       },
       ['police:object:delete'] = {
        title = "Delete Object",
        icon = "#global-delete",
        close = false,
        functiontype = "client",
        functionName = "nethush-police:client:delete:object"
       },
       ["mechanic:repair"] = {
           title = "Repair Vehicle",
           icon = "#citizen-action-vehicle",
           close = true,
           functiontype = "client",
           functionName = "ft-repair:client:triggerMenu",
       },
       ['ambulance:heal'] = {
         title = "Heal",
         icon = "#ambulance-action-heal",
         close = true,
         functiontype = "client",
         functionName = "nethush-hospital:client:heal:closest"
       },
       ['ambulance:revive'] = {
         title = "Revive",
         icon = "#ambulance-action-heal",
         close = true,
         functiontype = "client",
         functionName = "nethush-hospital:client:revive:closest"
       },
       ['ambulance:blood'] = {
         title = "Take Bloodsample",
         icon = "#ambulance-action-blood",
         close = true,
         functiontype = "client",
         functionName = "nethush-hospital:client:take:blood:closest"
       },
       ['ambulance:garage:heli'] = {
         title = "Augusta Westland 139",
         icon = "#police-action-vehicle-spawn",
         close = true,
         functionParameters = 'aw139',
         functiontype = "client",
         functionName = "nethush-hospital:client:spawn:vehicle"
       },
       ['ambulance:garage:touran'] = {
        title = "Command One Chevy",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'command2',
        functiontype = "client",
        functionName = "nethush-hospital:client:spawn:vehicle"
       },
       ['ambulance:garage:touran'] = {
           title = "Ambulance Engine One",
           icon = "#police-action-vehicle-spawn",
           close = true,
           functionParameters = '20ramambo',
           functiontype = "client",
           functionName = "nethush-hospital:client:spawn:vehicle"
          },
       ['ambulance:garage:sprinter'] = {
        title = "Command Two Ford",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'command1',
        functiontype = "client",
        functionName = "nethush-hospital:client:spawn:vehicle"
       },
       ['vehicle:delete'] = {
        title = "Delete Vehicle",
        icon = "#police-action-vehicle-delete",
        close = true,
        functiontype = "client",
        functionName = "Framework:Command:DeleteVehicle"
       },
       ['judge:tablet'] = {
        title = "Judge Tablet",
        icon = "#police-action-tablet",
        close = true,
        functiontype = "client",
        functionName = "nethush-judge:client:toggle"
       },
       ['judge:job'] = {
        title = "Hire Lawyer",
        icon = "#judge-actions",
        close = true,
        functiontype = "client",
        functionName = "nethush-judge:client:lawyer:add:closest"
       },
       ['citizen:contact'] = {
        title = "Share Contact",
        icon = "#citizen-contact",
        close = true,
        functiontype = "client",
        functionName = "qb-phone:client:GiveContactDetails"
       },
       ['citizen:escort'] = {
        title = "Escort",
        icon = "#citizen-action-escort",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:escort:closest"
       },
       ['citizen:steal'] = {
        title = "Rob",
        icon = "#citizen-action-steal",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:steal:closest"
       },
       ['citizen:vehicle:getout'] = {
        title = "Out Vehicle",
        icon = "#citizen-put-out-veh",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:SetPlayerOutVehicle"
       },
       ['citizen:vehicle:getin'] = {
        title = "In Vehicle",
        icon = "#citizen-put-in-veh",
        close = true,
        functiontype = "client",
        functionName = "nethush-police:client:PutPlayerInVehicle"
       },
       ['citizen:corner:selling'] = {
           title = "Cornersell",
           icon = "#animation-shady",
           close = true,
           functiontype = "client",
           functionName = "nethush-illegal:client:toggle:corner:selling"
       },
       ['vehicle:flip'] = {
        title = "Flip Vehicle",
        icon = "#citizen-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:flip:vehicle"
       },
       ['vehicle:key'] = {
        title = "Give Keys",
        icon = "#citizen-action-vehicle-key",
        close = true,
        functiontype = "client",
        functionName = "nethush-vehiclekeys:client:give:key"
       },
       ['vehicle:extra'] = {
           title = "Extra1",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 1,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
       ['vehicle:extra2'] = {
           title = "Extra2",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 2,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
       ['vehicle:extra3'] = {
           title = "Extra3",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 3,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
       ['vehicle:extra4'] = {
           title = "Extra4",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 4,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
       ['vehicle:extra5'] = {
           title = "Extra5",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 5,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
       ['vehicle:extra6'] = {
           title = "Extra6",
           icon = "#citizen-action-vehicle",
           close = false,
           functionParameters = 5,
           functiontype = "client",
           functionName = "nethush-radialmenu:client:setExtra"
       },
   
       ['vehicle:door:left:front'] = {
        title = "Left Front",
        icon = "#global-arrow-left",
        close = true,
        functionParameters = 0,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
       ['vehicle:door:motor'] = {
        title = "Hood",
        icon = "#global-arrow-up",
        close = true,
        functionParameters = 4,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
       ['vehicle:door:right:front'] = {
        title = "Right Front",
        icon = "#global-arrow-right",
        close = true,
        functionParameters = 1,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
       ['vehicle:door:right:back'] = {
        title = "Right Back",
        icon = "#global-arrow-right",
        close = true,
        functionParameters = 3,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
       ['vehicle:door:trunk'] = {
        title = "Trunk",
        icon = "#global-arrow-down",
        close = true,
        functionParameters = 5,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
       ['vehicle:door:left:back'] = {
        title = "Left Back",
        icon = "#global-arrow-left",
        close = true,
        functionParameters = 2,
        functiontype = "client",
        functionName = "nethush-radialmenu:client:open:door"
       },
   
   
       ['tow:hook'] = {
        title = "Tow Vehicle",
        icon = "#citizen-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "nethush-tow:client:hook:car"
       },
       ['tow:npc'] = {
        title = "Toggle NPC",
        icon = "#citizen-action",
        close = true,
        functiontype = "client",
        functionName = "nethush-tow:client:toggle:npc"
       },
       ['taxi:togglemeter'] = {
           title = "Show/Hide Meter",
           icon = "#taxi-meter",
           close = true,
           functiontype = "client",
           functionName = "nethush-taxi:client:toggleMeter"
          },
          ['taxi:mouse'] = {
           title = "Start/Stop Meter",
           icon = "#taxi-start",
           close = true,
           functiontype = "client",
           functionName = "nethush-taxi:client:enableMeter"
          },
          ['taxi:npc'] = {
           title = "NPC Missions",
           icon = "#taxi-npc",
           close = true,
           functiontype = "client",
          functionName = "nethush-taxi:client:DoTaxiNpc"
       },
   
   
   
       ['garage:putin'] = {
        title = "Park Vehicle",
        icon = "#citizen-put-in-veh",
        close = true,
        functiontype = "client",
        functionName = "nethush-garages:client:check:owner"
       },
       ['garage:getout'] = {
        title = "Take Vehicle",
        icon = "#citizen-put-out-veh",
        close = true,
        functiontype = "client",
        functionName = "nethush-garages:client:set:vehicle:out:garage"
       }, 
       ['house:setstash'] = {
        title = "Set Stash",
        icon = "#citizen-put-out-veh",
        close = true,
        functionParameters = 'stash',
        functiontype = "client",
        functionName = "nethush-housing:client:set:location"
       },
       ['house:setlogout'] = {
        title = "Set Logout",
        icon = "#citizen-put-out-veh",
        close = true,
        functionParameters = 'logout',
        functiontype = "client",
        functionName = "nethush-housing:client:set:location"
       },
       ['house:setclothes'] = {
        title = "Set Wardrobe",
        icon = "#citizen-put-out-veh",
        close = true,
        functionParameters = 'clothes',
        functiontype = "client",
        functionName = "nethush-housing:client:set:location"
       },
       ['house:givekey'] = {
        title = "Give Keys",
        icon = "#citizen-action-vehicle-key",
        close = true,
        functiontype = "client",
        functionName = "nethush-housing:client:give:keys"
       },
       ['house:decorate'] = {
        title = "Decorate",
        icon = "#global-box",
        close = true,
        functiontype = "client",
        functionName = "nethush-housing:client:decorate"
       },
       -- // Anims and Expression \\ --
       ['animations:brave'] = {
           title = "Brave",
           icon = "#animation-brave",
           close = true,
           functionName = "AnimSet:Brave",
           functiontype = "client",
       },
       ['animations:hurry'] = {
           title = "Hurry",
           icon = "#animation-hurry",
           close = true,
           functionName = "AnimSet:Hurry",
           functiontype = "client",
       },
       ['animations:business'] = {
           title = "Business",
           icon = "#animation-business",
           close = true,
           functionName = "AnimSet:Business",
           functiontype = "client",
       },
       ['animations:tipsy'] = {
           title = "Tipsy",
           icon = "#animation-tipsy",
           close = true,
           functionName = "AnimSet:Tipsy",
           functiontype = "client",
       },
       ['animations:injured'] = {
           title = "Injured",
           icon = "#animation-injured",
           close = true,
           functionName = "AnimSet:Injured",
           functiontype = "client",
       },
       ['animations:tough'] = {
           title = "Tough",
           icon = "#animation-tough",
           close = true,
           functionName = "AnimSet:ToughGuy",
           functiontype = "client",
       },
       ['animations:sassy'] = {
           title = "Sassy",
           icon = "#animation-sassy",
           close = true,
           functionName = "AnimSet:Sassy",
           functiontype = "client",
       },
       ['animations:sad'] = {
           title = "Sad",
           icon = "#animation-sad",
           close = true,
           functionName = "AnimSet:Sad",
           functiontype = "client",
       },
       ['animations:posh'] = {
           title = "Posh",
           icon = "#animation-posh",
           close = true,
           functionName = "AnimSet:Posh",
           functiontype = "client",
       },
       ['animations:alien'] = {
           title = "Alien",
           icon = "#animation-alien",
           close = true,
           functionName = "AnimSet:Alien",
           functiontype = "client",
       },
       ['animations:nonchalant'] =
       {
           title = "Nonchalant",
           icon = "#animation-nonchalant",
           close = true,
           functionName = "AnimSet:NonChalant",
           functiontype = "client",
       },
       ['animations:hobo'] = {
           title = "Hobo",
           icon = "#animation-hobo",
           close = true,
           functionName = "AnimSet:Hobo",
           functiontype = "client",
       },
       ['animations:money'] = {
           title = "Money",
           icon = "#animation-money",
           close = true,
           functionName = "AnimSet:Money",
           functiontype = "client",
       },
       ['animations:swagger'] = {
           title = "Swagger",
           icon = "#animation-swagger",
           close = true,
           functionName = "AnimSet:Swagger",
           functiontype = "client",
       },
       ['animations:shady'] = {
           title = "Shady",
           icon = "#animation-shady",
           close = true,
           functionName = "AnimSet:Shady",
           functiontype = "client",
       },
       ['animations:maneater'] = {
           title = "Man Eater",
           icon = "#animation-maneater",
           close = true,
           functionName = "AnimSet:ManEater",
           functiontype = "client",
       },
       ['animations:chichi'] = {
           title = "ChiChi",
           icon = "#animation-chichi",
           close = true,
           functionName = "AnimSet:ChiChi",
           functiontype = "client",
       },
       ['animations:default'] = {
           title = "Default",
           icon = "#animation-default",
           close = true,
           functionName = "AnimSet:default",
           functiontype = "client",
       },
       ["expressions:angry"] = {
           title="Angry",
           icon="#expressions-angry",
           close = true,
           functionName = "expressions",
           functionParameters =  { "mood_angry_1" },
           functiontype = "client",
       },
       ["expressions:drunk"] = {
           title="Drunk",
           icon="#expressions-drunk",
           close = true,
           functionName = "expressions",
           functionParameters =  { "mood_drunk_1" },
           functiontype = "client",
       },
       ["expressions:dumb"] = {
           title="Dumb",
           icon="#expressions-dumb",
           close = true,
           functionName = "expressions",
           functionParameters =  { "pose_injured_1" },
           functiontype = "client",
       },
       ["expressions:electrocuted"] = {
           title="Electrocuted",
           icon="#expressions-electrocuted",
           close = true,
           functionName = "expressions",
           functionParameters =  { "electrocuted_1" },
           functiontype = "client",
       },
       ["expressions:grumpy"] = {
           title="Grumpy",
           icon="#expressions-grumpy",
           close = true,
           functionName = "expressions", 
           functionParameters =  { "mood_drivefast_1" },
           functiontype = "client",
       },
       ["expressions:happy"] = {
           title="Happy",
           icon="#expressions-happy",
           close = true,
           functionName = "expressions",
           functionParameters =  { "mood_happy_1" },
           functiontype = "client",
       },
       ["expressions:injured"] = {
           title="Injured",
           icon="#expressions-injured",
           close = true,
           functionName = "expressions",
           functionParameters =  { "mood_injured_1" },
           functiontype = "client",
       },
       ["expressions:joyful"] = {
           title="Joyful",
           icon="#expressions-joyful",
           close = true,
           functionName = "expressions",
           functionParameters =  { "mood_dancing_low_1" },
           functiontype = "client",
       },
       ["expressions:mouthbreather"] = {
           title="Mouthbreather",
           icon="#expressions-mouthbreather",
           close = true,
           functionName = "expressions",
           functionParameters = { "smoking_hold_1" },
           functiontype = "client",
       },
       ["expressions:normal"]  = {
           title="Normal",
           icon="#expressions-normal",
           close = true,
           functionName = "expressions:clear",
           functiontype = "client",
       },
       ["expressions:oneeye"]  = {
           title="One Eye",
           icon="#expressions-oneeye",
           close = true,
           functionName = "expressions",
           functionParameters = { "pose_aiming_1" },
           functiontype = "client",
       },
       ["expressions:shocked"]  = {
           title="Shocked",
           icon="#expressions-shocked",
           close = true,
           functionName = "expressions",
           functionParameters = { "shocked_1" },
           functiontype = "client",
       },
       ["expressions:sleeping"]  = {
           title="Sleeping",
           icon="#expressions-sleeping",
           close = true,
           functionName = "expressions",
           functionParameters = { "dead_1" },
           functiontype = "client",
       },
       ["expressions:smug"]  = {
           title="Smug",
           icon="#expressions-smug",
           close = true,
           functionName = "expressions",
           functionParameters = { "mood_smug_1" },
           functiontype = "client",
       },
       ["expressions:speculative"]  = {
           title="Speculative",
           icon="#expressions-speculative",
           close = true,
           functionName = "expressions",
           functionParameters = { "mood_aiming_1" },
           functiontype = "client",
       },
       ["expressions:stressed"]  = {
           title="Stressed",
           icon="#expressions-stressed",
           close = true,
           functionName = "expressions",
           functionParameters = { "mood_stressed_1" },
           functiontype = "client",
       },
       ["expressions:sulking"]  = {
           title="Sulking",
           icon="#expressions-sulking",
           close = true,
           functionName = "expressions",
           functionParameters = { "mood_sulk_1" },
           functiontype = "client",
       },
       ["expressions:weird"]  = {
           title="Weird",
           icon="#expressions-weird",
           close = true,
           functionName = "expressions",
           functionParameters = { "effort_2" },
           functiontype = "client",
       },
       ["expressions:weird2"]  = {
           title="Weird 2",
           icon="#expressions-weird2",
           close = true,
           functionName = "expressions",
           functionParameters = { "effort_3" },
           functiontype = "client",
       }
}

RegisterNetEvent('nethush-radialmenu:client:update:duty:vehicles')
AddEventHandler('nethush-radialmenu:client:update:duty:vehicles', function()
   -- Config.Menu[11].subMenus = exports['nethush-police']:GetVehicleList()
end)