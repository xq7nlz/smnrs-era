--- @class LowestHpSelector : BaseTargetSelector
LowestHpSelector = Class(LowestHpSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function LowestHpSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function LowestHpSelector:_CompareTarget(hero1, hero2)
    if hero1.hp:GetValue() > hero2.hp:GetValue() then
        return 1
    elseif hero1.hp:GetValue() < hero2.hp:GetValue() then
        return -1
    else
        return 0
    end
end