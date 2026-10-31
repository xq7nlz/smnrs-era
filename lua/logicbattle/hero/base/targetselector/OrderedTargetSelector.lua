--- @class OrderedTargetSelector : BaseTargetSelector
OrderedTargetSelector = Class(OrderedTargetSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function OrderedTargetSelector:SelectSuitableTargets(availableTargets)
    availableTargets:Sort(self, self._CompareTarget)
    TargetSelectorUtils.RemoveRedundantTargetsAtTail(availableTargets, self.numberToSelected)

    return availableTargets
end

--- @return number
--- @param hero1 BaseHero
--- @param hero2 BaseHero
function OrderedTargetSelector:_CompareTarget(hero1, hero2)
    local positionInfo1 = hero1.positionInfo
    local positionInfo2 = hero2.positionInfo

    if positionInfo1.isFrontLine == positionInfo2.isFrontLine then
        return positionInfo1.position - positionInfo2.position
    else
        if positionInfo1.isFrontLine then
            return -1
        else
            return 1
        end
    end
end