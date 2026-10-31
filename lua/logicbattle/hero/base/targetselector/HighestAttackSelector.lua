--- @class HighestAttackSelector : BaseTargetSelector
HighestAttackSelector = Class(HighestAttackSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function HighestAttackSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function HighestAttackSelector:_CompareTarget(hero1, hero2)
    if hero1.attack:GetValue() > hero2.attack:GetValue() then
        return -1
    elseif hero1.attack:GetValue() < hero2.attack:GetValue() then
        return 1
    else
        return hero1.positionInfo:GetPositionUnique() - hero2.positionInfo:GetPositionUnique()
    end
end