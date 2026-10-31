--- @class PassiveItemOption : BaseItemOption
PassiveItemOption = Class(PassiveItemOption, BaseItemOption)

--- @return void
--- @param type ItemOptionType
--- @param data table
--- @param heroService HeroDataService
function PassiveItemOption:Ctor(type, data, heroService, itemService)
    BaseItemOption.Ctor(self, type, data)

    --- @type HeroDataService
    self.heroDataService = heroService

    --- @type ItemDataService
    self.itemDataService = itemService

    --- @type List<HeroFactionType>
    self.itemBearerHeroFaction = List()
    local factionData = self:GetOptionParam(2)
    if factionData ~= nil then
        local factions = factionData:Split(";")
        for i = 1, #factions do
            self.itemBearerHeroFaction:Add(tonumber(factions[i]))
        end
    end

    --- @type number
    self.passiveId = tonumber(self:GetOptionParam(1))

    --- @type ItemPassiveData
    self.itemPassiveData = itemService:GetItemPassiveData(self.passiveId)

end

--- @return void
function PassiveItemOption:Validate()

end

--- @return void
--- @param hero BaseHero
function PassiveItemOption:IsCanApplyToHero(hero)
    if self.itemBearerHeroFaction:Count() > 0 and
            self.itemBearerHeroFaction:IsContainValue(hero.originInfo.faction) == false then
        return false
    end

    return true
end

--- @return void
--- @param hero BaseHero
function PassiveItemOption:ApplyToHero(hero)
    if self:IsCanApplyToHero(hero) == false then
        return
    end

    local skillClass = self:GetItemPassiveLuaFile()
    local skill = skillClass:CreateInstance(1, hero)
    skill:SetData(1, self.itemPassiveData)

    hero.skillController:AddItemPassiveSkill(skill)
end

--- @return table
function PassiveItemOption:GetItemPassiveLuaFile()
    local path = string.format(LuaPathConstants.ITEM_PASSIVE_SKILL_PATH, self.passiveId)
    return require(path)
end