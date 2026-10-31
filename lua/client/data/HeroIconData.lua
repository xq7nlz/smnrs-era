
--- @class HeroIconData
HeroIconData = Class(HeroIconData)

--- @return void
function HeroIconData:Ctor()
    --- @type ResourceType
    self.type = nil
    --- @type number
    self.heroId = nil
    --- @type number
    self.star = nil
    --- @type number
    self.level = nil
    --- @type number
    self.faction = nil
    --- @type number
    self.quantity = nil
    --- @type number
    self.skinId = nil

    self.starLevel, self.starNumber, self.frameLevel, self.avatarLevel = nil
end

--- @return void
--- @param type ResourceType
--- @param heroId number
--- @param star number
--- @param level number
--- @param faction number
--- @param quantity number
function HeroIconData:SetData(type, heroId, star, level, faction, quantity, skinId)
    self.type = type
    self.heroId = heroId
    self.star = star
    self.level = level
    self.faction = faction
    self.quantity = quantity
    self.skinId = skinId
    if self.star ~= nil then
        self.starLevel, self.starNumber, self.frameLevel, self.avatarLevel = ClientConfigUtils.GetInfoIconByHeroStar(self.star)
    end
end

--- @return HeroIconData
--- @param data HeroIconData
function HeroIconData.Clone(data)
    return HeroIconData.CreateInstance(data.type, data.heroId, data.star, data.level, data.faction, data.quantity, data.skinId)
end

--- @return HeroIconData
--- @param type ResourceType
--- @param heroId number
--- @param star number
--- @param level number
--- @param faction number
--- @param quantity number
function HeroIconData.CreateInstance(type, heroId, star, level, faction, quantity, skinId)
    local heroIconData = HeroIconData()
    heroIconData:SetData(type, heroId, star, level, faction, quantity, skinId)
    return heroIconData
end

--- @return HeroIconData
--- @param heroResource HeroResource
function HeroIconData.CreateByHeroResourceStarterPack(heroResource)
    local heroFaction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)

    return HeroIconData.CreateInstance(ResourceType.Hero, heroResource.heroId, 5,
            1, heroFaction, nil, heroResource.heroItem:Get(HeroItemSlot.SKIN))
end

--- @return HeroIconData
--- @param heroResource HeroResource
function HeroIconData.CreateByHeroResource(heroResource)
    local heroFaction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)

    return HeroIconData.CreateInstance(ResourceType.Hero, heroResource.heroId, heroResource.heroStar,
            heroResource.heroLevel, heroFaction, nil, heroResource.heroItem:Get(HeroItemSlot.SKIN))
end

--- @return HeroIconData
--- @param heroBattleInfo HeroBattleInfo
function HeroIconData.CreateByHeroBattleInfo(heroBattleInfo)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroBattleInfo.heroId)
    return HeroIconData.CreateInstance(ResourceType.Hero, heroBattleInfo.heroId, heroBattleInfo.star,
            heroBattleInfo.level, faction, nil, heroBattleInfo.items:Get(HeroItemSlot.SKIN))
end