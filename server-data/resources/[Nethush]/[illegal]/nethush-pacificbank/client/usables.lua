ExplosiveRange = false
RegisterNetEvent("electronickit:UseElectronickit")
AddEventHandler(
    "electronickit:UseElectronickit",
    function()
        print("Used electronic kit.")
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist =
            GetDistanceBetweenCoords(
            pos.x,
            pos.y,
            pos.z,
            Config.PacificB["coords"]["x"],
            Config.PacificB["coords"]["y"],
            Config.PacificB["coords"]["z"],
            true
        )
        if dist < 3.0 then
            print("Within distance.")
            DrawMarker(
                2,
                Config.PacificB["coords"]["x"],
                Config.PacificB["coords"]["y"],
                Config.PacificB["coords"]["z"],
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.1,
                0.1,
                0.05,
                242,
                148,
                41,
                255,
                false,
                false,
                false,
                1,
                false,
                false,
                false
            )
            if CurrentCops >= Config.PacificBPolice then
                print("Current cops good.")
                if not Config.PacificB["isOpened"] then
                    print("Pacific bank is being robbed.")
                    QBCore.Functions.TriggerCallback(
                        "QBCore:HasItem",
                        function(result)
                            if result then
                                print("Has item.")
                                TriggerEvent("nethush-inventory:client:requiredItems", requiredItems, false)
                                print("Starting hack...")
                                exports["minigame-phone"]:ShowHack()
                                exports["minigame-phone"]:StartHack(
                                    math.random(3, 5),
                                    math.random(15, 22),
                                    function(Success)
                                        if Success then
                                            CreateTrollys()
                                            LockDownEnded = true
                                            pctjuhgekraakt = true
                                            deuropen = true
                                            TriggerServerEvent('qb-police:server:send:big:bank:alert', GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
                                            TriggerServerEvent("QBCore:Server:RemoveItem", "electronickit", 1)
                                            TriggerServerEvent("QBCore:Server:RemoveItem", "trojan_usb", 1)

                                            TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items["electronickit"], "remove")

                                            TriggerEvent("nethush-inventory:client:ItemBox", QBCore.Shared.Items["trojan_usb"], "remove")

                                            TriggerEvent("nethush-inventory:client:set:busy", false)

                                            TriggerServerEvent("nethush-doorlock:server:updateState", 36, false)

                                            TriggerServerEvent("nethush-pacific:server:set:trollyz", true)
                                        else
                                            TriggerEvent("swt_notifications:Infos",_U("failedtask"))
                                            TriggerEvent("nethush-inventory:client:set:busy", false)
                                        end
                                        exports["minigame-phone"]:HideHack()
                                    end
                                )
                            else
                                TriggerEvent("swt_notifications:Infos",_U("missingitem"))
                            end
                        end,
                        "trojan_usb"
                    )
                else
                    TriggerEvent("swt_notifications:Infos",_U("canthack"))
                end
            else
                TriggerEvent("swt_notifications:Infos",_U("nocops"))
            end
        end
    end
)

RegisterNetEvent("explosive:UseExplosivePacific")
AddEventHandler(
    "explosive:UseExplosivePacific",
    function()
        local Positie = GetEntityCoords(PlayerPedId())
        local dist =
            GetDistanceBetweenCoords(
            Positie.x,
            Positie.y,
            Positie.z,
            Config.PacificB["explosive"]["x"],
            Config.PacificB["explosive"]["y"],
            Config.PacificB["explosive"]["z"],
            true
        )
        if dist < 2.8 then
            ExplosiveRange = true
        else
            ExplosiveRange = false
        end
        if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", Positie)
        end
        if CurrentCops >= Config.PacificBPolice then
            if ExplosiveRange then
                QBCore.Functions.TriggerCallback(
                    "nethush-pacific:server:isRobberyActive",
                    function(isBusy)
                        if not isBusy then
                            TriggerEvent("nethush-inventory:client:busy:status", true)
                            GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_stickybomb"), 1, false, true)
                            Citizen.Wait(1000)
                            TaskPlantBomb(PlayerPedId(), Positie.x, Positie.y, Positie.z, 218.5)
                            TriggerServerEvent("QBCore:Server:RemoveItem", "explosive", 1)
                            TriggerServerEvent("nethush-pacific:server:DoSmokePfx")
                            TriggerServerEvent('qb-police:server:send:big:bank:alert', GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
                            TriggerEvent("nethush-inventory:client:busy:status", false)
                            local time = 5
                            local coords = GetEntityCoords(PlayerPedId())
                            while time > 0 do
                                Citizen.Wait(1000)
                                time = time - 1
                            end
                            AddExplosion(
                                Config.PacificB["explosive"]["x"],
                                Config.PacificB["explosive"]["y"],
                                Config.PacificB["explosive"]["z"],
                                EXPLOSION_STICKYBOMB,
                                4.0,
                                true,
                                false,
                                20.0
                            )
                            deuren = true
                            deuropen = true
                            TriggerServerEvent("nethush-doorlock:server:updateState", 35, false)
                            TriggerServerEvent("nethush-pacific:server:Klapdebank", true)
                            QBCore.Functions.TriggerCallback(
                                "nethush-pacific:server:PoliceAlertMessage",
                                function(result)
                                end,
                                "Pacific Bank",
                                Positie,
                                true
                            )
                        else
                            TriggerEvent("swt_notifications:Infos",_U("lockdownactive"))
                        end
                    end
                )
            else
                TriggerEvent("swt_notifications:Infos",_U("cannotuse"))
            end
        else
            TriggerEvent("swt_notifications:Infos",_U("nocops"))

            TriggerServerEvent("qb-scoreboard:server:SetActivityBusy", "humanelabs", false)
        end
    end
)

RegisterNetEvent("nethush-pacificbank:client:use:black-card")
AddEventHandler(
    "nethush-pacificbank:client:use:black-card",
    function()
        if not Config.PacificB["isOpenedStart"]["isOpened"] then
            local Area =
                GetDistanceBetweenCoords(
                GetEntityCoords(PlayerPedId()),
                Config.PacificB["isOpenedStart"]["x"],
                Config.PacificB["isOpenedStart"]["y"],
                Config.PacificB["isOpenedStart"]["z"],
                true
            )
            if Area < 1.35 then
                if CurrentCops >= Config.PacificBPolice then
                    QBCore.Functions.TriggerCallback(
                        "nethush-pacificbank:server:HasItem",
                        function(HasItem)
                            if HasItem then
                                if Config.PacificB["lights"] then
                                    TriggerEvent("nethush-inventory:client:set:busy", true)
                                    TriggerEvent("nethush-inventory:client:requiredItems", PacificItems, false)
                                    exports["minigame-phone"]:ShowHack()
                                    exports["minigame-phone"]:StartHack(
                                        math.random(1, 4),
                                        130,
                                        function(Success)
                                            if Success then
                                                TriggerEvent(
                                                    "utk_fingerprint:Start",
                                                    1,
                                                    1,
                                                    1,
                                                    function(Outcome)
                                                        if Outcome then
                                                            TriggerServerEvent('qb-police:server:send:big:bank:alert', GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
                                                            TriggerServerEvent("nethush-pacific:server:set:lights", false)
                                                            TriggerServerEvent(
                                                                "QBCore:Server:RemoveItem",
                                                                "black-card",
                                                                1
                                                            )
                                                            TriggerEvent(
                                                                "nethush-inventory:client:ItemBox",
                                                                QBCore.Shared.Items["black-card"],
                                                                "remove"
                                                            )
                                                            TriggerEvent("nethush-inventory:client:set:busy", false)
                                                            TriggerEvent("swt_notifications:Infos",_U("lightsoff"))
                                                            LockDownStart()
                                                        end
                                                    end
                                                )
                                            else
                                                TriggerServerEvent('qb-police:server:send:big:bank:alert', GetEntityCoords(PlayerPedId()), QBCore.Functions.GetStreetLabel())
                                                TriggerEvent("swt_notifications:Infos",_U("failed"))
                                                TriggerEvent("nethush-inventory:client:set:busy", false)
                                            end
                                            exports["minigame-phone"]:HideHack()
                                        end
                                    )
                                end
                            else
                                TriggerEvent("swt_notifications:Infos","You are missing something..")
                            end
                        end,
                        "electronickit"
                    )
                else
                    TriggerEvent("swt_notifications:Infos",_U("nocops"), "info")
                end
            end
        end
    end
)
