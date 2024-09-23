local Config = {
    HungerThreshold = 5, -- Seuil de faim pour maintenir
    ThirstThreshold = 5  -- Seuil de soif pour maintenir
}

-- Variables pour stocker l'état actuel
local previousWalkstyle = nil
local isBlurApplied = false
local needsBelowThreshold = false

-- Fonction pour appliquer ou retirer le flou
local function setBlur(shouldApply)
    if shouldApply then
        -- Appliquer l'effet de flou si ce n'est pas déjà appliqué
        if not isBlurApplied then
            SetTimecycleModifier('hud_def_blur')
            SetTimecycleModifierStrength(1.0)  -- Ajustez la force du flou selon vos préférences
            isBlurApplied = true
        end
    else
        -- Retirer l'effet de flou si appliqué
        if isBlurApplied then
            ClearTimecycleModifier()
            isBlurApplied = false
        end
    end
end

-- Fonction pour appliquer le walkstyle injured
local function applyInjuredWalkstyle()
    SetPedMovementClipset(PlayerPedId(), "move_m@injured", 0.2)
end

-- Fonction pour réappliquer le walkstyle précédent
local function applyPreviousWalkstyle()
    if previousWalkstyle then
        SetPedMovementClipset(PlayerPedId(), previousWalkstyle, 0.2)
    else
        ResetPedMovementClipset(PlayerPedId(), 0.2)
    end
end

-- Fonction pour maintenir la faim et la soif au-dessus des seuils
local function regulateNeeds()
    CreateThread(function()
        while true do
            Wait(1000) -- Vérifier toutes les secondes
            -- Demander les valeurs de la faim et de la soif au serveur
            TriggerServerEvent('requestPlayerNeeds')
        end
    end)
end

-- Fonction pour vérifier les besoins du joueur et appliquer les modifications nécessaires
local function checkAndApplyNeeds(hunger, thirst)
    local blurNeeded = hunger <= Config.HungerThreshold or thirst <= Config.ThirstThreshold
    setBlur(blurNeeded)

    if blurNeeded then
        -- Appliquer le walkstyle injured lorsque les besoins sont sous le seuil
        if not needsBelowThreshold then
            applyInjuredWalkstyle()
            needsBelowThreshold = true
        end
    else
        -- Réappliquer le walkstyle précédent lorsque les besoins sont au-dessus du seuil
        if needsBelowThreshold then
            applyPreviousWalkstyle()
            needsBelowThreshold = false
        end
    end
end

-- Boucle pour appliquer le walkstyle injured si les besoins sont en dessous du seuil
CreateThread(function()
    while true do
        Wait(1000) -- Vérifier toutes les secondes
        local ped = PlayerPedId()
        if needsBelowThreshold then
            -- Vérifiez si le walkstyle est déjà appliqué
            if GetPedMovementClipset(ped) ~= "move_m@injured" then
                applyInjuredWalkstyle()
            end
        end
    end
end)

-- Gérer la réponse du serveur avec les valeurs de faim et de soif
RegisterNetEvent('updatePlayerNeeds')
AddEventHandler('updatePlayerNeeds', function(hunger, thirst)
    -- Vérifier les besoins et appliquer les modifications nécessaires
    checkAndApplyNeeds(hunger, thirst)

    -- Réguler la faim si nécessaire
    if hunger <= Config.HungerThreshold then
        TriggerServerEvent('setPlayerHunger', Config.HungerThreshold)
    end

    -- Réguler la soif si nécessaire
    if thirst <= Config.ThirstThreshold then
        TriggerServerEvent('setPlayerThirst', Config.ThirstThreshold)
    end
end)

-- Démarrer la régulation des besoins
regulateNeeds()