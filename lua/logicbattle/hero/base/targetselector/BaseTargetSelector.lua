--- @class BaseTargetSelector
--- Base class for all other TargetSelector
BaseTargetSelector = Class(BaseTargetSelector)

--- @return void
--- @param hero BaseHero
function BaseTargetSelector:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    --- @type TargetPositionType
    self.targetPositionType = nil
    --- @type TargetTeamType
    self.targetTeamType = nil
    --- @type number
    self.numberToSelected = nil
    --- @type boolean
    self.includeSelf = true
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param targetPositionType TargetPositionType
--- @param targetTeamType TargetTeamType
--- @param numberToSelected number
function BaseTargetSelector:SetInfo(targetPositionType, targetTeamType, numberToSelected)
    --assert(MathUtils.IsInteger(targetPositionType) and targetPositionType > 0)
    --assert(MathUtils.IsInteger(targetTeamType) and targetTeamType >= TargetTeamType.ALLY and targetTeamType <= TargetTeamType.BOTH)
    --assert(MathUtils.IsInteger(numberToSelected) and numberToSelected > 0)

    self.targetPositionType = targetPositionType
    self.targetTeamType = targetTeamType
    self.numberToSelected = numberToSelected

    --print(string.format("targetPositionType = %s, targetTeamType = %s, numberToSelected = %s",
    --        self.targetPositionType, self.targetTeamType, self.numberToSelected))
end

--- @return void
--- @param includeSelf boolean
function BaseTargetSelector:SetIncludeSelf(includeSelf)
    self.includeSelf = includeSelf
end

---------------------------------------- Getters ----------------------------------------
--- @return List<BaseHero>
--- @param attackerTeam BattleTeam
--- @param defenderTeam BattleTeam
function BaseTargetSelector:GetAvailableTargets(attackerTeam, defenderTeam)
    ---@type List<BaseHero>
    local selectedTargets
    if self.targetTeamType == TargetTeamType.ENEMY then
        local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
        selectedTargets = self:_FilterCanBeTargetedList(enemyTeam.heroList)

    elseif self.targetTeamType == TargetTeamType.ALLY then
        local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
        selectedTargets = self:_FilterCanBeTargetedList(allyTeam.heroList)

    else
        --- TargetTeamType.BOTH
        ---@type  BattleTeam
        local enemyTeam = TargetSelectorUtils.GetEnemyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
        local enemyTargets = self:_FilterCanBeTargetedList(enemyTeam.heroList)

        local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
        local allyTargets = self:_FilterCanBeTargetedList(allyTeam.heroList)

        selectedTargets = List()
        selectedTargets:AddAll(enemyTargets)
        selectedTargets:AddAll(allyTargets)
    end

    self:_ExcludeSelfIfNeeded(selectedTargets)
    return selectedTargets
end

--- @return List<BaseHero>
--- @param heroList table
function BaseTargetSelector:_FilterCanBeTargetedList(heroList)
    local targetList = List()
    for i = 1, heroList:Count() do
        local hero = heroList:Get(i)
        if TargetSelectorUtils.CanBeTargeted(hero, self.targetTeamType) then
            targetList:Add(hero)
        end
    end
    return targetList
end

--- @return void
--- @param heroList List<BaseHero>
function BaseTargetSelector:_ExcludeSelfIfNeeded(heroList)
    if self.includeSelf == false then
        local i = 1
        while i <= heroList:Count() do
            local hero = heroList:Get(i)
            if hero == self.myHero then
                heroList:RemoveByIndex(i)
                break
            end
            i = i + 1
        end
    end
end

---------------------------------------- Public methods ----------------------------------------
--- @return List<BaseHero>
--- @param battle Battle
function BaseTargetSelector:SelectTarget(battle)
    local availableTargets
    if self.targetPositionType == TargetPositionType.SELF then
        availableTargets = List()
        if TargetSelectorUtils.CanBeTargeted(self.myHero, self.targetTeamType) and self.includeSelf == true then
            availableTargets:Add(self.myHero)
        end
    else
        local attackerTeam, defenderTeam = battle:GetTeam()
        availableTargets = self:GetAvailableTargets(attackerTeam, defenderTeam)
    end

    return self:SelectSuitableTargets(availableTargets)
end

---------------------------------------- Abstracts ----------------------------------------
--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function BaseTargetSelector:SelectSuitableTargets(availableTargets)
    assert(false, "this method should be overridden by child class")
end