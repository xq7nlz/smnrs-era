--- @class LinkingManager
LinkingManager = Class(LinkingManager)

--- @return void
--- @param battleService BattleService
--- @param attackerTeam BattleTeam
--- @param defenderTeam BattleTeam
function LinkingManager:PrepareBattle(battleService, attackerTeam, defenderTeam)
    local heroLinkingDataService = battleService:GetHeroLinkingDataService()
    local linkingGroups = heroLinkingDataService:GetHeroLinkingEntries()

    self:AddLinkingBuffForTeam(attackerTeam, linkingGroups)
    self:AddLinkingBuffForTeam(defenderTeam, linkingGroups)
end

--- @return void
--- @param team BattleTeam
--- @param linkingGroups Dictionary<number, BaseLinking>
function LinkingManager:AddLinkingBuffForTeam(team, linkingGroups)

    local activeGroups = team:GetLinkingGroups()
    for group, level in pairs(activeGroups:GetItems()) do

        --- @type BaseLinking
        local linking = linkingGroups:Get(group)
        if linking ~= nil then
            linking:AddEffectToTeam(team, level)
            team:AddLinking(linking)
        end
    end
end