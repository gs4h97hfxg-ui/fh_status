local ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('hud:requestMoney', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount('bank').money

    TriggerClientEvent('hud:updateMoney', src, cash, bank)
end)
