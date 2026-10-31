--- @class TargetSelectorUtils
TargetSelectorUtils = {}

--- @return BattleTeam
--- @param attackerTeam BattleTeam
--- @param defenderTeam BattleTeam
--- @param teamId number
function TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, teamId)
    if attackerTeam.teamId == teamId then
        return attackerTeam
    else
        return defenderTeam
    end
end

--- @return BattleTeam
--- @param attackerTeam BattleTeam
--- @param defenderTeam BattleTeam
--- @param teamId number
function TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, teamId)
    if attackerTeam.teamId ~= teamId then
        return attackerTeam
    else
        return defenderTeam
    end
end

--- @return List<BaseHero>
--- @param target BaseHero
--- @param range number
function TargetSelectorUtils.GetNearTarget(target, range)
    local result = List()
    local attackerTeam, defenderTeam = target.battle:GetTeam()
    local targetTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, target.teamId)

    local mainTargetPos = target.positionInfo.position
    local sameLineWithTarget
    if target.positionInfo.isFrontLine == true then
        sameLineWithTarget = targetTeam.frontLine
    else
        sameLineWithTarget = targetTeam.backLine
    end

    for i = 1, range do
        local nearRight = mainTargetPos + i
        if sameLineWithTarget[nearRight] ~= nil and sameLineWithTarget[nearRight]:IsDead() == false then
            result:Add(sameLineWithTarget[nearRight])
        end

        local nearLeft = mainTargetPos - i
        if sameLineWithTarget[nearLeft] ~= nil and sameLineWithTarget[nearLeft]:IsDead() == false then
            result:Add(sameLineWithTarget[nearLeft])
        end
    end

    return result
end

--- @return List<BaseHero>
--- @param battle Battle
--- @param myHero BaseHero
--- @param targetPosition number
--- @param teamType TargetTeamType
--- @param targetNumber number
function TargetSelectorUtils.SelectTarget(battle, myHero, targetPosition, teamType, targetNumber)
    local targetSelector = TargetSelectorBuilder.Create(myHero, targetPosition,
            teamType, targetNumber)

    if teamType == TargetTeamType.ALLY then
        return targetSelector:SelectTarget(battle)
    end

    return TargetSelectorUtils.SelectTargetForFocusMark(battle, myHero, targetPosition, targetNumber)
end

--- @return List<BaseHero>
--- @param battle Battle
--- @param myHero BaseHero
--- @param targetPosition number
--- @param targetNumber number
function TargetSelectorUtils.SelectTargetForFocusMark(battle, myHero, targetPosition, targetNumber)
    local result = List()
    local attackerTeam, defenderTeam = battle:GetTeam()

    local targetSelector = TargetSelectorBuilder.Create(myHero, targetPosition,
            TargetTeamType.ENEMY, targetNumber)

    local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, myHero.teamId)
    local focusingHeroList = allyTeam:GetHeroWithMark(EffectType.FOCUS_MARK)
    if focusingHeroList:Count() == 0 then
        return targetSelector:SelectTarget(battle)
    end

    --- get first hero focusing to define target by taunt mark
    local focusingHero = focusingHeroList:Get(1)
    local focusMark = focusingHero.effectController:GetDistinctEffectWithType(EffectType.FOCUS_MARK)
    local tauntTarget = focusMark.focusTarget
    if tauntTarget == nil or tauntTarget:CanBeTargetedByEnemy() == false then
        return targetSelector:SelectTarget(battle)
    end

    result:Add(tauntTarget)
    if targetNumber <= 1 then
        return result
    end

    if targetPosition == TargetPositionType.PREFER_FRONT_LINE
            or targetPosition == TargetPositionType.PREFER_BACK_LINE then
        if tauntTarget.positionInfo.isFrontLine == true then
            targetSelector = TargetSelectorBuilder.Create(myHero, TargetPositionType.PREFER_FRONT_LINE,
                    TargetTeamType.ENEMY, targetNumber)
            result = targetSelector:SelectTarget(battle)
        else
            targetSelector = TargetSelectorBuilder.Create(myHero, TargetPositionType.PREFER_BACK_LINE,
                    TargetTeamType.ENEMY, targetNumber)
            result = targetSelector:SelectTarget(battle)
        end
    else
        result = targetSelector:SelectTarget(battle)
    end

    if result:Count() > 0 and result:IsContainValue(tauntTarget) == false then
        result:RemoveByIndex(1)
        result:Add(tauntTarget)
    end
    return result
end

--- @return boolean can be targeted or not
--- @param hero BaseHero
--- @param targetTeamType TargetTeamType
function TargetSelectorUtils.CanBeTargeted(hero, targetTeamType)
    if targetTeamType == TargetTeamType.ENEMY then
        return hero:CanBeTargetedByEnemy()
    elseif targetTeamType == TargetTeamType.ALLY then
        return hero:CanBeTargetedByAlly()
    else
        return hero:CanBeTargetedByEnemy() or hero:CanBeTargetedByAlly()
    end
end

--- @return List<BaseHero>
--- @param targetList List<BaseHero>
--- @param numberToSelected number
--- @param randomHelper RandomHelper
function TargetSelectorUtils.RemoveRandomRedundantTargets(targetList, numberToSelected, randomHelper)
    -- remove random heroes until number conditions met
    if targetList:Count() > numberToSelected then
        local numberToRemove = targetList:Count() - numberToSelected
        targetList:RemoveRandomItems(numberToRemove, randomHelper)
    end
    return targetList
end

--- @return List<BaseHero>
--- @param targetList List<BaseHero>
--- @param numberToSelected number
function TargetSelectorUtils.RemoveRedundantTargetsAtTail(targetList, numberToSelected)
    -- remove heroes at tail of list until number conditions met
    if targetList:Count() > numberToSelected then
        local numberToRemove = targetList:Count() - numberToSelected
        for _ = 1, numberToRemove do
            targetList:RemoveByIndex(targetList:Count())
        end
    end
    return targetList
end

return TargetSelectorUtils