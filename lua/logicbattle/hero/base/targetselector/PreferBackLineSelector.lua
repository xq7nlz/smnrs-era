--- @class PreferBackLineSelector : BaseTargetSelector
PreferBackLineSelector = Class(PreferBackLineSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function PreferBackLineSelector:SelectSuitableTargets(availableTargets)
    local backLineTargets = List()
    local i = 1
    while i <= availableTargets:Count() do
        local hero = availableTargets:Get(i)
        if hero.positionInfo.isFrontLine == false then
            backLineTargets:Add(hero)
        end
        i = i + 1
    end

    --- If hero in backLine can still be targeted, don't fallback to frontLine
    if backLineTargets:Count() > 0 then
        TargetSelectorUtils.RemoveRandomRedundantTargets(backLineTargets, self.numberToSelected, self.myHero.randomHelper)
        return backLineTargets
    end

    TargetSelectorUtils.RemoveRandomRedundantTargets(availableTargets, self.numberToSelected, self.myHero.randomHelper)
    return availableTargets
end