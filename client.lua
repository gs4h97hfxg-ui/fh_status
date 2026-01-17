local ESX = exports.es_extended:getSharedObject()

local lastHealth, lastArmor, lastHunger, lastThirst = -1, -1, -1, -1
local lastSpeed, lastFuel = -1, -1
local lastTalking = false

-- Player Grunddaten (einmalig beim Laden)
local function initHUD()
    Wait(500)
    lib.sendNuiMessage('hud:init', {
        playerId = GetPlayerServerId(PlayerId()),
        serverName = GetConvar('sv_hostname', 'FiveM Server')
    })
    TriggerServerEvent('hud:requestMoney')
end

RegisterNetEvent('esx:playerLoaded', function()
    initHUD()
end)

-- Falls das Script restartet wird und der Spieler bereits da ist
CreateThread(function()
    if ESX.IsPlayerLoaded() then
        initHUD()
    end
end)

-- Geld-Updates (eventbasiert)
RegisterNetEvent('hud:updateMoney', function(cash, bank)
    lib.sendNuiMessage('hud:money', {
        cash = cash,
        bank = bank
    })
end)

-- ESX Money Events (Triggered whenever money changes)
RegisterNetEvent('esx:setAccountMoney', function()
    TriggerServerEvent('hud:requestMoney')
end)

RegisterNetEvent('esx:addInventoryItem', function()
    TriggerServerEvent('hud:requestMoney')
end)

-- Status Loop (Health, Armor, Hunger, Thirst, Voice)
CreateThread(function()
    while true do
        Wait(500)

        local ped = cache.ped
        if not ped then goto continue end

        local health = math.floor((GetEntityHealth(ped) - 100))
        if health < 0 then health = 0 end

        local armor = GetPedArmour(ped)
        local talking = MumbleIsPlayerTalking(PlayerId()) -- Better for pma-voice

        -- Hunger & Thirst from ESX Status
        local hunger, thirst = 0, 0
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = math.floor(status.getPercent())
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = math.floor(status.getPercent())
        end)

        if health ~= lastHealth or armor ~= lastArmor or hunger ~= lastHunger or thirst ~= lastThirst or talking ~= lastTalking then
            lastHealth = health
            lastArmor = armor
            lastHunger = hunger
            lastThirst = thirst
            lastTalking = talking

            lib.sendNuiMessage('hud:status', {
                health = health,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                talking = talking
            })
        end

        ::continue::
    end
end)

-- Vehicle Loop (Speed, Fuel)
CreateThread(function()
    while true do
        local vehicle = cache.vehicle

        if not vehicle then
            lib.sendNuiMessage('hud:vehicle', { inVehicle = false })
            Wait(1000)
            goto continue
        end

        Wait(150)

        local speed = math.floor(GetEntitySpeed(vehicle) * 3.6) -- KMH
        local fuel = math.floor(Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle))

        if speed ~= lastSpeed or fuel ~= lastFuel then
            lastSpeed = speed
            lastFuel = fuel

            lib.sendNuiMessage('hud:vehicle', {
                inVehicle = true,
                speed = speed,
                fuel = fuel
            })
        end

        ::continue::
    end
end)
