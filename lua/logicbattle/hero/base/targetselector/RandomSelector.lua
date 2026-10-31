--- @class RandomSelector : BaseTargetSelector
RandomSelector = Class(RandomSelector, BaseTargetSelector)

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function RandomSelector:SelectSuitableTargets(availableTargets)
    TargetSelectorUtils.RemoveRandomRedundantTargets(availableTargets, self.numberToSelected, self.myHero.randomHelper)

    return availableTargets
end