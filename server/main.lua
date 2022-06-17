local sharedItems = exports['qbr-core']:GetItems()

RegisterServerEvent("qbr-graveyard:server:reward")
AddEventHandler("qbr-graveyard:server:reward", function()
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
    for i = 1, Config.RegularX, 1 do
        local randItem1 = Config.GraveYardLoot["regular"]["items"][math.random(1, #Config.GraveYardLoot["regular"]["items"])]
        local amount1 = Config.RegularAmount
        Player.Functions.AddItem(randItem1, amount1)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[randItem1], 'add')
    end

    local odd2 = math.random(1, 4)
    local chance2 = math.random(1, 4)
    if odd2 == chance2 then
        local randItem2 = Config.GraveYardLoot["valuables"]["items"][math.random(1, #Config.GraveYardLoot["valuables"]["items"])]
        local amount2 = Config.ValuablesAmount
        Player.Functions.AddItem(randItem2, amount2)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[randItem2], 'add')
    end
    if Config.CashReward == true then
    Player.Functions.AddMoney("cash", Config.CurrencyAmount)
    end
end)

RegisterNetEvent('qbr-graveyard:server:setGraveStatus', function(grave)
    Config.Graves[grave].robbed = true
    Config.Graves[grave].time = Config.resetTime
    TriggerClientEvent('qbr-graveyard:client:setGraveStatus', -1, grave, Config.Graves[grave])
end)

CreateThread(function()
    while true do
        local toSend = {}
        for k in ipairs(Config.Graves) do

            if Config.Graves[k].time > 0 and (Config.Graves[k].time - Config.tickInterval) >= 0 then
                Config.Graves[k].time = Config.Graves[k].time - Config.tickInterval
            else
                if Config.Graves[k].robbed then
                    Config.Graves[k].time = 0
                    Config.Graves[k].robbed = false
                    toSend[#toSend+1] = Config.Graves[k]
                end
            end
        end

        if #toSend > 0 then
            TriggerClientEvent('qbr-graveyard:client:setGraveStatus', -1, toSend, false)
        end

        Wait(Config.tickInterval)
    end
end)

exports['qbr-core']:CreateUseableItem("gy_shovel", function(source, item)
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("shovel:UseShovel", src)
	end
end)
