--- @class StatChangerItemOption : BaseItemOption
StatChangerItemOption = Class(StatChangerItemOption, BaseItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
--- @param heroService HeroDataService
function StatChangerItemOption:Ctor(type, data, heroService)
    BaseItemOption.Ctor(self, type, data)

    --- @type HeroDataService
    self.heroDataService = heroService

    --- @type StatType
    self.statType = tonumber(self:GetOptionParam(1))

    --- @type List<DamageAgainstItemOption>
    self.amount = tonumber(self:GetOptionParam(2))

    --- @type StatChangerCalculationType
    self.calculationType = self:GetOptionParam(3)
    if self.calculationType == nil then
        self.calculationType = StatChangerCalculationType.PERCENT_ADD
    else
        self.calculationType = tonumber(self.calculationType)
    end

    --- @type List<HeroClassType>
    self.affectedHeroClass = List()
    local classData = self:GetOptionParam(4)
    if classData ~= nil then
        local classes = classData:Split(";")
        for i = 1, #classes do
            self.affectedHeroClass:Add(tonumber(classes[i]))
        end
    end

    --- @type List<HeroFactionType>
    self.affectedHeroFaction = List()
    local factionData = self:GetOptionParam(5)
    if factionData ~= nil then
        local factions = factionData:Split(";")
        for i = 1, #factions do
            self.affectedHeroFaction:Add(tonumber(factions[i]))
        end
    end

    --- @type number
    self.requirementGroupType = self:GetOptionParam(6)
    if self.requirementGroupType == nil then
        self.requirementGroupType = ItemConstants.ITEM_OPTION_ALL_OF_REQUIREMENT
    end

    --- @type List<number>
    self.affectedHeroId = List()
    local idData = self:GetOptionParam(7)
    if idData ~= nil then
        local ids = idData:Split(";")
        for i = 1, #ids do
            self.affectedHeroId:Add(tonumber(ids[i]))
        end
    end
end

--- @return void
function StatChangerItemOption:Validate()
    if StatType.IsValidType(self.statType) == false then
        assert(false)
    end

    if self.amount <= 0 then
        assert(false)
    end

    if StatChangerCalculationType.IsValidType(self.calculationType) == false then
        assert(false)
    end

    for i = 1, self.affectedHeroClass:Count() do
        if HeroClassType.IsValidType(self.affectedHeroClass:Get(i)) == false then
            assert(false)
        end
    end

    for i = 1, self.affectedHeroFaction:Count() do
        if HeroFactionType.IsValidType(self.affectedHeroFaction:Get(i)) == false then
            assert(false)
        end
    end

    for i = 1, self.affectedHeroId:Count() do
        local heroId = self.affectedHeroId:Get(i)
        if self.heroDataService:GetHeroDataEntry(heroId) == nil then
            assert(false)
        end
    end
end

--- @return void
--- @param hero BaseHero
function StatChangerItemOption:IsCanApplyToHero(hero)
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

        if self.affectedHeroId:Count() > 0 and self.affectedHeroId:IsContainValue(hero.id) == false then
            return false
        end
    end

    return true
end

--- @return void
--- @param hero BaseHero
function StatChangerItemOption:ApplyToHero(hero)
    if self:IsCanApplyToHero(hero) == false then
        return
    end

    local optionEffect = StatChangerEffect(hero, hero, true)
    optionEffect:SetPersistentType(EffectPersistentType.PERMANENT)
    optionEffect:SetDuration(EffectConstants.INFINITY_DURATION)
    optionEffect:SetEffectSource(StatChangerEffectSource.ITEM)

    local statChanger = StatChanger(true)
    statChanger:SetInfo(self.statType, self.calculationType, self.amount)
    optionEffect:AddStatChanger(statChanger)

    hero.effectController:AddEffect(optionEffect)
end