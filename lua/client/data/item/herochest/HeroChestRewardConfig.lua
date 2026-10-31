local ITEM_CHEST_HERO_PATH = "csv/item/hero_chest_select/hero_chest_select.csv"

--- @class HeroChestRewardConfig
HeroChestRewardConfig = Class(HeroChestRewardConfig)

--- @return void
function HeroChestRewardConfig:Ctor()
    ---@type Dictionary
    self.listArenaChestRewardConfig = Dictionary()
    self:ReadChestHeroRewardConfig()
end

function HeroChestRewardConfig:ReadChestHeroRewardConfig()
    ---@type List
    self.listChestNormalHeroRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ITEM_CHEST_HERO_PATH)
    if parsedData == nil then
        XDebug.Error(string.format("Chest reward config missing: ", ITEM_CHEST_HERO_PATH ))
        return
    end
    local lastChestId= nil
    for i = 1, #parsedData do
        if parsedData[i]["chest_id"] ~= nil then
            lastChestId = tonumber(parsedData[i]["chest_id"])
            self.listChestNormalHeroRewardConfig:Add(lastChestId, List())
            self.listChestNormalHeroRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        else
            self.listChestNormalHeroRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        end
    end
end

function HeroChestRewardConfig:GetChestNormalHeroRewardConfig(heroChestId)
    return self.listChestNormalHeroRewardConfig:Get(heroChestId)
end

return HeroChestRewardConfig