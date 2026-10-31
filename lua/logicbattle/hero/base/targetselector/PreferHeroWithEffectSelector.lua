--- @class PreferHeroWithEffectSelector : BaseTargetSelector
PreferHeroWithEffectSelector = Class(PreferHeroWithEffectSelector, BaseTargetSelector)

--- @return void
--- @param hero BaseHero
function PreferHeroWithEffectSelector:Ctor(hero)
    BaseTargetSelector.Ctor(self, hero)

    --- @type EffectType
    self.effectType = nil
end

--- @return void
--- @param effectType EffectType
function PreferHeroWithEffectSelector:SetEffectType(effectType)
    self.effectType = effectType
end

--- @return List<BaseHero>
--- @param availableTargets List<BaseHero>
function PreferHeroWithEffectSelector:SelectSuitableTargets(availableTargets)
    if availableTargets:Count() > self.numberToSelected then
        local selectedTargets = List()
        local targetsWithoutEffect = List()

        local i = 1
        while i <= availableTargets:Count() do
            local target = availableTargets:Get(i)
            if target.effectController:IsContainEffectType(self.effectType) == true then
                selectedTargets:Add(target)
            else
                targetsWithoutEffect:Add(target)
            end
            i = i + 1
        end

        if selectedTargets:Count() > self.numberToSelected then
            local numberToRemove = selectedTargets:Count() - self.numberToSelected
            selectedTargets:RemoveRandomItems(numberToRemove, self.myHero.randomHelper)

        elseif selectedTargets:Count() < self.numberToSelected then
            local numberToAdd = self.numberToSelected - selectedTargets:Count()
            for _ = 1, numberToAdd do
                if targetsWithoutEffect:Count() == 0 then
                    break
                end

                local index = self.myHero.randomHelper:RandomMinMax(1, targetsWithoutEffect:Count() + 1)

                selectedTargets:Add(targetsWithoutEffect:Get(index))
                targetsWithoutEffect:RemoveByIndex(index)
            end
        end

        return selectedTargets
    end

    return availableTargets
end