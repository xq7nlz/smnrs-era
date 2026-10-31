--- @class ReduceDamageAgainstItemOption : DamageItemOption
ReduceDamageAgainstItemOption = Class(ReduceDamageAgainstItemOption, DamageItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
--- @param heroService HeroDataService
function ReduceDamageAgainstItemOption:Ctor(type, data, heroService)
    DamageItemOption.Ctor(self, type, data)

    --- @type HeroDataService
    self.heroDataService = heroService

    --- @type List<number>
    self.affectedHeroes = List()
    local classData = self:GetOptionParam(7)
    if classData ~= nil then
        local classes = classData:Split(";")
        for i = 1, #classes do
            self.affectedHeroes:Add(tonumber(classes[i]))
        end
    end
end

--- @return void
function ReduceDamageAgainstItemOption:Validate()
    DamageItemOption.Validate(self)

    for i = 1, self.affectedHeroes:Count() do
        if self.heroDataService:GetHeroDataEntry(self.affectedHeroes:Get(i)) == nil then
            assert(false)
        end
    end
end

--- @return void
--- @param hero BaseHero
function ReduceDamageAgainstItemOption:ApplyToHero(hero)
    if DamageItemOption.IsCanApplyToHero(self, hero) == false then
        return
    end

    hero.battleHelper:AddDamageItemOption(self)
end

--- @return void
--- @param hero BaseHero
function ReduceDamageAgainstItemOption:IsCanApplyToEnemy(hero)
    if self.requirementGroupType == ItemConstants.ITEM_OPTION_ALL_OF_REQUIREMENT then
        if self.affectedHeroClass:Count() > 0 and self.affectedHeroClass:IsContainValue(hero.originInfo.class) == false then
            return false
        end

        if self.affectedHeroFaction:Count() > 0 and self.affectedHeroFaction:IsContainValue(hero.originInfo.faction) == false then
            return false
        end

        if self.affectedHeroes:Count() > 0 and self.affectedHeroes:IsContainValue(hero.id) == false then
            return false
        end
    else
        if self.affectedHeroClass:Count() > 0 and self.affectedHeroClass:IsContainValue(hero.originInfo.class) == false then
            if self.affectedHeroFaction:Count() > 0 and self.affectedHeroFaction:IsContainValue(hero.originInfo.faction) == false then
                if self.affectedHeroes:Count() > 0 and self.affectedHeroes:IsContainValue(hero.id) == false then
                    return false
                end
            end
        end
    end

    return true
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
function ReduceDamageAgainstItemOption:CalculateDamage(target, totalDamage)
    if self:IsCanApplyToEnemy(target) == false then
        return totalDamage
    end

    local lastAmount = 1 - self.amount
    if lastAmount < 0 then
        lastAmount = 0
    end

    return totalDamage * lastAmount
end