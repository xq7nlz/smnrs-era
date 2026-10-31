--- @class IndexPositionSelector : BaseTargetSelector
IndexPositionSelector = Class(IndexPositionSelector, BaseTargetSelector)

---@return void
---@param hero BaseHero
function IndexPositionSelector:Ctor(hero)
    BaseTargetSelector.Ctor(self, hero)

    ---@type List<number>
    self.listIndexMatch = nil
end

--- @return void
--- @param targetPositionType TargetPositionType
--- @param targetTeamType TargetTeamType
--- @param numberToSelected number
function IndexPositionSelector:SetInfo(targetPositionType, targetTeamType, numberToSelected)
    BaseTargetSelector.SetInfo(self, targetPositionType, targetTeamType, numberToSelected)
    local numberTarget = numberToSelected
    self.listIndexMatch = List()
    while numberTarget > 0 do
        local index = numberTarget % 10
        if self.listIndexMatch:IsContainValue(index) == false then
            self.listIndexMatch:Add(index)
        end
        numberTarget = math.floor(numberTarget / 10)
    end
end

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function IndexPositionSelector:SelectSuitableTargets(availableTargets)
    local result = List {}
    local i = 1
    while i <= availableTargets:Count() do
        local target = availableTargets:Get(i)

        local slotIndex = self:GetSlotIndex(target.teamId, target.positionInfo.isFrontLine, target.positionInfo.position)
        if self.listIndexMatch:IsContainValue(slotIndex) then
            result:Add(target)
        end
        i = i + 1
    end
    return result
end

function IndexPositionSelector:GetSlotIndex(teamId, isFrontLine, position)
    if isFrontLine then
        return position
    else
        --- @type BattleTeam
        local targetBattleTeam = self.myHero.battle:GetTeamById(teamId)
        return position + targetBattleTeam.battleTeamInitializer.formationData.frontLine
    end
end