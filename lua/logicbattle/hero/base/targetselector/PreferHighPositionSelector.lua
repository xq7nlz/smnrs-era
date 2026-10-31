--- @class PreferHighPositionSelector : BaseTargetSelector
PreferHighPositionSelector = Class(PreferHighPositionSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function PreferHighPositionSelector:SelectSuitableTargets(availableTargets)
    local listResult = List()
    local maxIndex = -1
    local targetHero
    for i = 1, availableTargets:Count() do
        local target = availableTargets:Get(i)
        local slotIndex = self:GetSlotIndex(target.teamId, target.positionInfo.isFrontLine, target.positionInfo.position)
        if slotIndex >= maxIndex then
            maxIndex = slotIndex
            targetHero = target
        end
    end
    if (targetHero ~= nil) then
        listResult:Add(targetHero)
    end
    return listResult
end

function PreferHighPositionSelector:GetSlotIndex(teamId, isFrontLine, position)
    if isFrontLine then
        return position
    else
        --- @type BattleTeam
        local targetBattleTeam = self.myHero.battle:GetTeamById(teamId)
        return position + targetBattleTeam.battleTeamInitializer.formationData.frontLine
    end
end