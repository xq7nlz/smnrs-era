--- @class DamageItemOption : BaseItemOption
DamageItemOption = Class(DamageItemOption, BaseItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
function DamageItemOption:Ctor(type, data)
    BaseItemOption.Ctor(self, type, data)

    --- @type number
    self.amount = tonumber(self:GetOptionParam(1))

    --- @type HeroClassType
    self.itemBearerHeroClass = tonumber(self:GetOptionParam(2))

    --- @type List<HeroClassType>
    self.affectedHeroClass = List()
    local classData = self:GetOptionParam(3)
    if classData ~= nil then
        local classes = classData:Split(";")
        for i = 1, #classes do
            self.affectedHeroClass:Add(tonumber(classes[i]))
        end
    end

    --- @type List<HeroFactionType>
    self.affectedHeroFaction = List()
    local factionData = self:GetOptionParam(4)
    if factionData ~= nil then
        local factions = factionData:Split(";")
        for i = 1, #factions do
            self.affectedHeroFaction:Add(tonumber(factions[i]))
        end
    end

    --- @type number
    self.requirementGroupType = self:GetOptionParam(5)
    if self.requirementGroupType == nil then
        self.requirementGroupType = ItemConstants.ITEM_OPTION_ALL_OF_REQUIREMENT
    end
end

--- @return void
function DamageItemOption:Validate()
    if self.amount <= 0 then
        assert(false)
    end

    if self.itemBearerHeroClass ~= nil and self.itemBearerHeroClass ~= ItemConstants.ITEM_OPTION_NO_PARAM then
        if HeroClassType.IsValidType(self.itemBearerHeroClass) == false then
            assert(false)
        end
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
end

--- @return void
--- @param hero BaseHero
function DamageItemOption:IsCanApplyToHero(hero)
    if self.itemBearerHeroClass ~= nil and self.itemBearerHeroClass ~= ItemConstants.ITEM_OPTION_NO_PARAM then
        if hero.originInfo.class ~= self.itemBearerHeroClass then
            -- not match hero bearer class requirement
            return false
        end
    end

    return true
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
function DamageItemOption:CalculateDamage(target, totalDamage)
    assert(false, "this method should be overridden by child class")
end