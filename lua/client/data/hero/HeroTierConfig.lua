local HERO_TIER = "csv/hero/hero_tier.csv"
--- @class HeroTierConfig
HeroTierConfig = Class(HeroTierConfig)

function HeroTierConfig:Ctor()
    --- @type Dictionary
    self.tierDict = nil
    self:Init()
end

function HeroTierConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_TIER)
    self.tierDict = Dictionary()
    for i = 1, #parsedData do
        local data = parsedData[i]
        self.tierDict:Add(tonumber(data.hero_id), tonumber(data.tier))
    end
end

function HeroTierConfig:GetHeroTier(heroId)
    return self.tierDict:Get(heroId)
end

--- @return 1 if greater, 0 if equal, -1 if less
function HeroTierConfig:Compare(id1, id2)
    local tier1 = self:GetHeroTier(id1)
    local tier2 = self:GetHeroTier(id2)
    if tier1 > tier2 then
        return 1
    elseif tier1 == tier2 then
        return 0
    else
        return -1
    end
end

return HeroTierConfig