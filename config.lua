Config = {}

--Rewards
Config.RewardChance = 25 

Config.CashReward = true -- true gets cash, false gets no cash
Config.CurrencyAmount = math.random(50, 150)

Config.RegularX = math.random(1,3) -- this number is multiplied by regular loot
Config.RegularAmount = 10
Config.ValuablesAmount = 2
Config.GraveYardLoot = {
    ["regular"] = {
        ["items"] = {
            'cash_roll_blood', 
        }
    },
    ["valuables"] = {
        ["items"] = {
            'gold_coins',
            'silver_coins',
        }
    }
}

--Alerts ( If you are using rsg_alerts and you want alerts keep true otherwise make false)
Config.Alerts = true

--Minigame
Config.Seconds = math.random(10, 12)
Config.Circles = math.random(3, 5)

--Item break
Config.ShovelBreak = 20 -- Lower the smaller chance of breaking (Currently 20%)

Config.resetTime = (60 * 1000) * 30 -- Every 30 minutes the store can be robbed again
Config.tickInterval = 1000 -- Ignore

Config.Graves = {
    [1] = {vector3(1283.01, -1246.9, 79.47),  robbed = false, time = 0},
    [2] = {vector3(1285.04, -1245.4, 79.79),  robbed = false, time = 0},
    [3] = {vector3(1276.94, -1242.92, 79.7),  robbed = false, time = 0},
    [4] = {vector3(1279.07, -1241.45, 79.99), robbed = false, time = 0},
    [5] = {vector3(1280.91, -1240.58, 80.26), robbed = false, time = 0},
    [6] = {vector3(1276.85, -1235.48, 80.42), robbed = false, time = 0},
    [7] = {vector3(1274.43, -1236.7, 80.2),   robbed = false, time = 0},
    [8] = {vector3(1272.34, -1237.24, 79.94), robbed = false, time = 0},
}
