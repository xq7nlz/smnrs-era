--- @class PreferFrontLineSelector : BaseTargetSelector
PreferFrontLineSelector = Class(PreferFrontLineSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function PreferFrontLineSelector:SelectSuitableTargets(availableTargets)
    local frontLineTargets = List()
    local i = 1
    while i <= availableTargets:Count() do
        local hero = availableTargets:Get(i)
        if hero.positionInfo.isFrontLine == true then
            frontLineTargets:Add(hero)
        end
        i = i + 1
    end

    --- If hero in frontLine can still be targeted, don't fallback to backLine
    if frontLineTargets:Count() > 0 then
        TargetSelectorUtils.RemoveRandomRedundantTargets(frontLineTargets, self.numberToSelected, self.myHero.randomHelper)
        return frontLineTargets
    end

    TargetSelectorUtils.RemoveRandomRedundantTargets(availableTargets, self.numberToSelected, self.myHero.randomHelper)
    return availableTargets
end