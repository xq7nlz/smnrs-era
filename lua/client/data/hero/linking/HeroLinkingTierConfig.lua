require("lua.client.data.Hero.Linking.ItemLinkingTierConfig")

--- @class HeroLinkingTierConfig
HeroLinkingTierConfig = Class(HeroLinkingTierConfig)

local CSV_PATH = "csv/hero_linking/bonus_tier_config.csv"
local BASE_CONFIG_PATH = "csv/hero_linking/base_config.csv"

function HeroLinkingTierConfig:Ctor()
    self.listItemLinking = List()
    self.dictHeroIDInLinking = Dictionary()
    self:_ReadCsv()
    self:ReadBaseConfig()
end

function HeroLinkingTierConfig:_ReadCsv()
    --- @type Dictionary
    self.avatarConfigDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_PATH)
    ---@type ItemLinkingTierConfig
    local cacheItemLinking = nil
    for i = 1, #parsedData do
        if parsedData[i].id ~= nil then
            cacheItemLinking = ItemLinkingTierConfig()
            cacheItemLinking:ParsedData(parsedData[i])
            self.listItemLinking:Add(cacheItemLinking)
        else
            cacheItemLinking:AddBonus(parsedData[i])
        end
    end
    self.dictHeroIDInLinking = Dictionary()
    ---@param itemLinkingTierConfig ItemLinkingTierConfig
    for _, itemLinkingTierConfig in ipairs(self.listItemLinking:GetItems()) do
        for _, heroID in ipairs(itemLinkingTierConfig.listHero:GetItems()) do
            local minStar = self.dictHeroIDInLinking:Get(heroID)
            if minStar == nil or minStar > itemLinkingTierConfig.minStar then
                self.dictHeroIDInLinking:Add(heroID, itemLinkingTierConfig.minStar)
            end
        end
    end
end

function HeroLinkingTierConfig:GetAllLinkingConfig()
    return self.listItemLinking
end

function HeroLinkingTierConfig:GetLinkingConfigExceptHidden()
    if not self.listItemLinking or self.listItemLinking:Count() == 0 then
        self:_ReadCsv()
    end
    local list = List()
    ---@param v ItemLinkingTierConfig
    for k, v in pairs(self.listItemLinking:GetItems()) do
        if not v.isHide then
            list:Add(v)
        end
    end
    return list
end

--- @return number
---@param x ItemLinkingTierConfig
---@param y ItemLinkingTierConfig
function HeroLinkingTierConfig.SortLinkingId(x, y)
    if (x.id > y.id) then
        return -1
    else
        return 1
    end
end

function HeroLinkingTierConfig:ReadBaseConfig()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(BASE_CONFIG_PATH)
    self.numberHeroSupport = tonumber(parsedData[1].number_hero_support)
    self.intervalTime = tonumber(parsedData[1].interval_time)
    self.activeDuration = tonumber(parsedData[1].inactive_duration)
end

function HeroLinkingTierConfig:GetStarIdByGroupSlot(groupId, slot)
    for i = 1, self.listItemLinking:Count() do
        --- @type ItemLinkingTierConfig
        local itemLinking = self.listItemLinking:Get(i)
        if itemLinking.id == groupId then
            local heroId = itemLinking:GetHeroIdBySlotIndex(slot)
            return itemLinking.minStar, heroId
        end
    end
    return nil, nil
end

---@return number
---@param heroId number
function HeroLinkingTierConfig:GetMinStarByHeroId(heroId)
    return self.dictHeroIDInLinking:Get(heroId)
end

--- @return ItemLinkingTierConfig
function HeroLinkingTierConfig:GetItemLinkingByGroup(groupId)
    return self.listItemLinking:Get(groupId)
end

return HeroLinkingTierConfig