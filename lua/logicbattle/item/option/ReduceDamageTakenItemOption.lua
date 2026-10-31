--- @class ReduceDamageTakenItemOption : DamageItemOption
ReduceDamageTakenItemOption = Class(ReduceDamageTakenItemOption, DamageItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
--- @param heroService HeroDataService
function ReduceDamageTakenItemOption:Ctor(type, data, heroService)
    DamageItemOption.Ctor(self, type, data)

    --- @type HeroDataService
    self.heroDataService = heroService

    --- @type List<HeroFactionType>
    self.itemBearerHeroFaction = List()
    local factionData = self:GetOptionParam(6)
    if factionData ~= nil then
        local factions = factionData:Split(";")
        for i = 1, #factions do
            self.itemBearerHeroFaction:Add(tonumber(factions[i]))
        end
    end

    --- @type number
    self.itemBearerHeroId = nil
    local heroData = self:GetOptionParam(7)
    if heroData ~= nil then
        self.itemBearerHeroId = tonumber(heroData)
    end
end

--- @return void
function ReduceDamageTakenItemOption:Validate()
    DamageItemOption.Validate(self)

    if self.itemBearerHeroId ~= nil and self.heroDataService:GetHeroDataEntry(self.itemBearerHeroId) == nil then
        assert(false)
    end
end

--- @return void
--- @param hero BaseHero
function ReduceDamageTakenItemOption:ApplyToHero(hero)
    if self:IsCanApplyToHero(hero) == false then
        return
    end

    hero.hp:AddDamageItemOption(self)
end

--- @return void
--- @param hero BaseHero
function ReduceDamageTakenItemOption:IsCanApplyToHero(hero)
    if DamageItemOption:IsCanApplyToHero(hero) == false then
        return false
    end

    if self.itemBearerHeroId ~= nil and self.itemBearerHeroId ~= ItemConstants.ITEM_OPTION_NO_PARAM then
        if hero.id ~= self.itemBearerHeroId then
            -- not match hero bearer hero id requirement
            return false
        end
    end

    if self.itemBearerHeroFaction:Count() > 0 and self.itemBearerHeroFaction:IsContainValue(hero.originInfo.faction) == false then
        return false
    end

    return true
end

--- @return void
--- @param hero BaseHero
function ReduceDamageTakenItemOption:IsCanApplyToEnemy(hero)
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
function ReduceDamageTakenItemOption:CalculateDamage(target, totalDamage)
    if self:IsCanApplyToEnemy(target) == false then
        return totalDamage
    end

    return totalDamage * (1 - self.amount)
end