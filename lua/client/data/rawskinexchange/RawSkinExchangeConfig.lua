local SKIN_EXCHANGE_PATH = "csv/item/skin/skin_exchange_price.csv"

--- @class RawSkinExchangeConfig
RawSkinExchangeConfig = Class(RawSkinExchangeConfig)

function RawSkinExchangeConfig:Ctor()
    --- @type List
    self.listSkinItem = nil

    --- @type Dictionary
    self.skinExchangeDict = nil
end

function RawSkinExchangeConfig:GetConfig()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKIN_EXCHANGE_PATH)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", SKIN_EXCHANGE_PATH))
        return
    end
    self.listSkinItem = List()

    self.skinExchangeDict = Dictionary()

    --- @type {id, moneyType, moneyValue, rewardList, limit}
    local skinItem
    for i = 1, #parsedData do
        local data = parsedData[i]
        local id = tonumber(data.id)
        if id ~= nil then
            skinItem = {}
            skinItem.id = id
            skinItem.moneyType = tonumber(data.money_type)
            skinItem.moneyValue = tonumber(data.money_value)
            skinItem.rewardList = List()
            skinItem.limit = tonumber(data.limit)
            self.listSkinItem:Add(skinItem)

            local rewardInBound = RewardInBound.CreateByParams(data)
            skinItem.rewardList:Add(rewardInBound)
            self.skinExchangeDict:Add(rewardInBound.id, skinItem)
        end
    end
end

function RawSkinExchangeConfig:GetListSkinItem()
    if self.listSkinItem == nil or self.skinExchangeDict == nil then
        self:GetConfig()
    end
    return self.listSkinItem
end

--- @return {id, moneyType, moneyValue, rewardList, limit}
function RawSkinExchangeConfig:GetSkinItemConfigBySkinId(skinId)
    self:GetListSkinItem()
    return self.skinExchangeDict:Get(skinId)
end

return RawSkinExchangeConfig

