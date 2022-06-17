PlayerJob = exports['qbr-core']:GetPlayerData().job
local sharedItems = exports['qbr-core']:GetItems()
local currentGrave   = 0

CreateThread(function()
    Wait(1000)
    if exports['qbr-core'].GetPlayerData().job ~= nil and next(exports['qbr-core'].GetPlayerData().job) then
        PlayerJob = exports['qbr-core'].GetPlayerData().job
    end
end)

CreateThread(function()
    Wait(1000)
    buildGraves()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k in pairs(Config.Graves) do
            local dist = #(pos - Config.Graves[k][1].xyz)
        end
        if not inRange then
            Wait(2000)
        end
        Wait(3)
    end
end)

RegisterNetEvent('shovel:UseShovel', function()
    for k in pairs(Config.Graves) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Graves[k][1].xyz)
        if dist <= 1 and not Config.Graves[k].robbed then
            shovelUse()
            currentGrave = k
            if Config.Alerts == true then
                local alertcoords = GetEntityCoords(PlayerPedId())
                local blipname = 'Grave Disturbance'
                local alertmsg = 'People are tampering with graves'
                TriggerEvent('rsg_alerts:client:lawmanalert', alertcoords, blipname, alertmsg)
            end
        end
    end
end)

function buildGraves()
    exports['qbr-core']:TriggerCallback('qbr-graveyard:server:getGraveStatus', function(Graves)
        for k in pairs(Graves) do
            Config.Graves[k].robbed = Graves[k].robbed
        end
    end)
end

function shovelUse()
    if currentGrave ~= 0 then
        local seconds = Config.Seconds
        local circles = Config.Circles
        local success = exports['qbr-lock']:StartLockPickCircle(circles, seconds, success)
        if success then
        TriggerServerEvent('qbr-graveyard:server:setGraveStatus', currentGrave)
            exports['qbr-core']:Progressbar("dig_grave", "Digging", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb_work@world_human_gravedig@working@male_b@idle_a",
                anim = "idle_a",
                flags = 1,
            }, {}, {}, function() -- Done
                ClearPedTasks(PlayerPedId()) 
                if math.random(1, 100) > Config.RewardChance then  
                TriggerServerEvent('qbr-graveyard:server:reward')
                else
                    exports['qbr-core']:Notify(8, 'Grave Was Empty', 4000, '', 'menu_textures', 'cross', 'COLOR_GREEN') 
                end
            end, function() -- Cancel
                ClearPedTasks(PlayerPedId())
                exports['qbr-core']:Notify(8, 'Cancelled', 5000, '', 'menu_textures', 'cross', 'COLOR_GREEN')
                currentGrave = 0
            end)
        else 
            if math.random(1, 100) > Config.ShovelBreak then
                TriggerServerEvent('QBCore:Server:RemoveItem', "gy_shovel", 1)
                TriggerEvent("inventory:client:ItemBox", sharedItems["gy_shovel"], "remove")
                exports['qbr-core']:Notify(8, 'Shovel Snapped', 5000, '', 'multiwheel_weapons', 'kit_collector_spade', 'COLOR_GREEN')
           
                end
            end
        end
    end

-- Ignore
RegisterNetEvent('qbr-graveyard:client:setGraveStatus', function(batch, val)
    if(type(batch) ~= "table") then
        Config.Graves[batch] = val
    else
        for k in pairs(batch) do
            Config.Graves[k] = batch[k]
        end
    end
end)
