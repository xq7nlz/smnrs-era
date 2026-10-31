--- @class PreferHeroClassSelector : BaseTargetSelector
PreferHeroClassSelector = Class(PreferHeroClassSelector, BaseTargetSelector)

---@return void
---@param hero BaseHero
function PreferHeroClassSelector:Ctor(hero)
    BaseTargetSelector.Ctor(self, hero)

    ---@type HeroClassType
    self.heroClassType = nil
end

--- @return void
--- @param heroClassType HeroClassType
function PreferHeroClassSelector:SetAffectedClass(heroClassType)
    self.heroClassType = heroClassType
end

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function PreferHeroClassSelector:SelectSuitableTargets(availableTargets)
    local selectedTargets = List()
    local i = 1
    while i <= availableTargets:Count() do
        local hero = availableTargets:Get(i)
        if hero.originInfo.class == self.heroClassType then
            selectedTargets:Add(hero)
        end
        i = i + 1
    end

    TargetSelectorUtils.RemoveRandomRedundantTargets(selectedTargets, self.numberToSelected, self.myHero.randomHelper)
    return selectedTargets
end