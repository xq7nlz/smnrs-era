--- @class HighestDefenseSelector : BaseTargetSelector
HighestDefenseSelector = Class(HighestDefenseSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function HighestDefenseSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function HighestDefenseSelector:_CompareTarget(hero1, hero2)
    if hero1.defense:GetValue() < hero2.defense:GetValue() then
        return 1
    elseif hero1.defense:GetValue() > hero2.defense:GetValue() then
        return -1
    else
        return 0
    end
end