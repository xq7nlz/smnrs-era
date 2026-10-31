--- @class DamageAgainstItemOption : DamageItemOption
DamageAgainstItemOption = Class(DamageAgainstItemOption, DamageItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
--- @param heroService HeroDataService
function DamageAgainstItemOption:Ctor(type, data, heroService)
    DamageItemOption.Ctor(self, type, data)

    --- @type HeroDataService
    self.heroDataService = heroService

    --- @type number
    self.itemBearerHeroId = nil
    local heroData = self:GetOptionParam(7)
    if heroData ~= nil then
        self.itemBearerHeroId = tonumber(heroData)
    end
end

--- @return void
function DamageAgainstItemOption:Validate()
    DamageItemOption.Validate(self)

    if self.itemBearerHeroId ~= nil and self.heroDataService:GetHeroDataEntry(self.itemBearerHeroId) == nil then
        assert(false)
    end
end

--- @return void
--- @param hero BaseHero
function DamageAgainstItemOption:ApplyToHero(hero)
    if self:IsCanApplyToHero(hero) == false then
        return
    end

    hero.battleHelper:AddDamageItemOption(self)
end

--- @return void
--- @param hero BaseHero
function DamageAgainstItemOption:IsCanApplyToHero(hero)
    if DamageItemOption:IsCanApplyToHero(hero) == false then
        return false
    end

    if self.itemBearerHeroId ~= nil and self.itemBearerHeroId ~= ItemConstants.ITEM_OPTION_NO_PARAM then
        if hero.id ~= self.itemBearerHeroId then
            -- not match hero bearer hero id requirement
            return false
        end
    end

    return true
end

--- @return void
--- @param hero BaseHero
function DamageAgainstItemOption:IsCanApplyToEnemy(hero)
    if self.requirementGroupType == ItemConstants.ITEM_OPTION_ALL_OF_REQUIREMENT then
        if self.affectedHeroClass:Count() > 0 and self.affectedHeroClass:IsContainValue(hero.originInfo.class) == false then
            return false
        end

        if self.affectedHeroFaction:Count() > 0 and self.affectedHeroFaction:IsContainValue(hero.originInfo.faction) == false then
            return false
        end
    else
        if self.affectedHeroClass:Count() > 0 and self.affectedHeroClass:IsContainValue(hero.originInfo.class) == false then
            if self.affectedHeroFaction:Count() > 0 and self.affectedHeroFaction:IsContainValue(hero.originInfo.faction) == false then
                return false
            end
        end
    end

    return true
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
function DamageAgainstItemOption:CalculateDamage(target, totalDamage)
    if self:IsCanApplyToEnemy(target) == false then
        return totalDamage
    end

    return totalDamage * (1 + self.amount)
end