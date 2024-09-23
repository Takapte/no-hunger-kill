-- Assurez-vous que QBCore est correctement référencé
local QBCore = exports['qb-core']:GetCoreObject()

-- Événement pour obtenir les besoins du joueur
RegisterNetEvent('requestPlayerNeeds')
AddEventHandler('requestPlayerNeeds', function()
    local _source = source
    local player = QBCore.Functions.GetPlayer(_source)
    
    if player then
        local hunger = player.PlayerData.metadata["hunger"]
        local thirst = player.PlayerData.metadata["thirst"]
        TriggerClientEvent('updatePlayerNeeds', _source, hunger, thirst)
    end
end)

-- Événement pour définir la faim du joueur
RegisterNetEvent('setPlayerHunger')
AddEventHandler('setPlayerHunger', function(value)
    local _source = source
    local player = QBCore.Functions.GetPlayer(_source)
    
    if player then
        player.Functions.SetMetaData('hunger', value)
    end
end)

-- Événement pour définir la soif du joueur
RegisterNetEvent('setPlayerThirst')
AddEventHandler('setPlayerThirst', function(value)
    local _source = source
    local player = QBCore.Functions.GetPlayer(_source)
    
    if player then
        player.Functions.SetMetaData('thirst', value)
    end
end)
