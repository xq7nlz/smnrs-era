--- @class LowestDefenseSelector : BaseTargetSelector
LowestDefenseSelector = Class(LowestDefenseSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function LowestDefenseSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function LowestDefenseSelector:_CompareTarget(hero1, hero2)
    if hero1.defense:GetValue() > hero2.defense:GetValue() then
        return 1
    elseif hero1.defense:GetValue() < hero2.defense:GetValue() then
        return -1
    else
        return 0
    end
end