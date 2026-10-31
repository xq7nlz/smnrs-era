local CHALLENGE_SKIN_EXCHANGE_CONFIG_PATH = "csv/event/event_skin_challenge/data_%d/skin_exchange.csv"

--- @class EventSkinChallengeSkinExchangeConfig
EventSkinChallengeSkinExchangeConfig = Class(EventSkinChallengeSkinExchangeConfig)
function EventSkinChallengeSkinExchangeConfig:Ctor()
    --- @type List
    self.listExchangeSkin = List()
    self:GetSkinExchangeConfig()
end

--- @return List
function EventSkinChallengeSkinExchangeConfig:GetSkinExchangeConfig()
    local dataId = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE).timeData.dataId
    local path = string.format(CHALLENGE_SKIN_EXCHANGE_CONFIG_PATH, dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parsedData do
        local data = parsedData[i]
        local dict = {}
        dict.id = tonumber(data["id"])
        dict.moneyType = tonumber(data["money_type"])
        dict.moneyValue = tonumber(data["money_value"])
        dict.resourceType = tonumber(data["res_type"])
        dict.resourceId = tonumber(data["res_id"])
        dict.resourceNumber = tonumber(data["res_number"])
        dict.resourceData = tonumber(data["res_data"])
        dict.limit = tonumber(data["limit"])
        self.listExchangeSkin:Add(data)
    end
    return self.listExchangeSkin
end

return EventSkinChallengeSkinExchangeConfig