--- @class HighestHpPercentSelector : BaseTargetSelector
HighestHpPercentSelector = Class(HighestHpPercentSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function HighestHpPercentSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function HighestHpPercentSelector:_CompareTarget(hero1, hero2)
    if hero1.hp:GetStatPercent() > hero2.hp:GetStatPercent() then
        return -1
    elseif hero1.hp:GetStatPercent() < hero2.hp:GetStatPercent() then
        return 1
    else
        return 0
    end
end