local ESX = exports.es_extended:getSharedObject()

local lastHealth, lastArmor, lastStamina = -1, -1, -1
local lastSpeed, lastFuel, lastRPM = -1, -1, -1
local lastTalking = false

-- Player Grunddaten (einmalig)
AddEventHandler('esx:playerLoaded', function()
    lib.sendNuiMessage('hud:init', {
        playerId = GetPlayerServerId(PlayerId()),
        serverName = GetConvar('sv_hostname', 'FiveM Server')
    })

    TriggerServerEvent('hud:requestMoney')
end)

-- Geld-Updates (eventbasiert)
RegisterNetEvent('hud:updateMoney', function(cash, bank)
    lib.sendNuiMessage('hud:money', {
        cash = cash,
        bank = bank
    })
end)

-- ESX Money Events
AddEventHandler('esx:setAccountMoney', function()
    TriggerServerEvent('hud:requestMoney')
end)

-- Status Loop
CreateThread(function()
    while true do
        Wait(400)

        local ped = cache.ped
        if not ped then goto continue end

        local health = GetEntityHealth(ped) - 100
        local armor = GetPedArmour(ped)
        local stamina = GetPlayerSprintStaminaRemaining(PlayerId())
        local talking = NetworkIsPlayerTalking(PlayerId())

        if health ~= lastHealth or armor ~= lastArmor or stamina ~= lastStamina or talking ~= lastTalking then
            lastHealth = health
            lastArmor = armor
            lastStamina = stamina
            lastTalking = talking

            lib.sendNuiMessage('hud:status', {
                health = health,
                armor = armor,
                stamina = stamina,
                talking = talking
            })
        end

        ::continue::
    end
end)

-- Vehicle Loop
CreateThread(function()
    while true do
        Wait(200)

        local vehicle = cache.vehicle
        if not vehicle then
            lib.sendNuiMessage('hud:vehicle', { inVehicle = false })
            goto continue
        end

        local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
        local fuel = Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
        local rpm = math.floor(GetVehicleCurrentRpm(vehicle) * 100)

        if speed ~= lastSpeed or fuel ~= lastFuel or rpm ~= lastRPM then
            lastSpeed = speed
            lastFuel = fuel
            lastRPM = rpm

            lib.sendNuiMessage('hud:vehicle', {
                inVehicle = true,
                speed = speed,
                fuel = fuel,
                rpm = rpm
            })
        end

        ::continue::
    end
end)
