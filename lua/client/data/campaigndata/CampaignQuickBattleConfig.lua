local CAMPAIGN_QUICK_BATTLE_PATH = "csv/campaign/quick_battle/campaign_quick_battle_config.csv"

--- @class CampaignQuickBattleConfig
CampaignQuickBattleConfig = Class(CampaignQuickBattleConfig)

function CampaignQuickBattleConfig:Ctor()
    --- @type number
    self.duration = nil
    --- @type number
    self.maxBuyTurn = nil
    --- @type number
    self.quickBattleWatchAdLimit = nil
    --- @type Dictionary--<number, ItemIconData>
    self.buyTurnDictionary = Dictionary()

    self:InitData()
end

function CampaignQuickBattleConfig:InitData()
    self:ParseCsv(CsvReaderUtils.ReadAndParseLocalFile(CAMPAIGN_QUICK_BATTLE_PATH))
end

--- @data string
function CampaignQuickBattleConfig:ParseCsv(parsedData)
    self.duration = tonumber(parsedData[1]['quick_battle_duration'])
    self.maxBuyTurn = tonumber(parsedData[1]['quick_battle_max_buy_turn'])
    self.quickBattleWatchAdLimit = tonumber(parsedData[1]['quick_battle_watch_ads_limit'])

    for _, v in ipairs(parsedData) do
        local buyTurn = tonumber(v['quick_battle_buy_turn'])
        local resourceType = ResourceType.Money
        local resourceId = tonumber(v['money_type'])
        local quantity = tonumber(v['money_value'])
        local itemIconData = ItemIconData.CreateInstance(resourceType, resourceId, quantity)
        self.buyTurnDictionary:Add(buyTurn, itemIconData)
    end
end

--- @return ItemIconData
--- @param turn number
function CampaignQuickBattleConfig:GetPriceBuyTurn(turn)
    if self.buyTurnDictionary:IsContainKey(turn) then
        return self.buyTurnDictionary:Get(turn)
    end
    XDebug.Log("There is no quick battle turn id ", turn)
end

return CampaignQuickBattleConfig