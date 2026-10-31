local TEMP_CSV_PATH = "csv/event/event_battle_pass/data_%d/exchange_skin.csv"

---@class BattlePassExchangeConfig
BattlePassExchangeConfig = Class(BattlePassExchangeConfig)

--- @return void
function BattlePassExchangeConfig:Ctor()
    self.listExchangeItem = List()
    self:InitData()
end

--- @return void
function BattlePassExchangeConfig:InitData()
    ---@type EventEasterEggModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    local CSV_PATH = string.format(TEMP_CSV_PATH, eventModel.timeData.dataId)

    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_PATH)
    for i = 1, #parsedData do
        self:ParseCsv(parsedData[i])
    end
    return self.listExchangeItem
end

--- @return void
--- @param data string
function BattlePassExchangeConfig:ParseCsv(data)
    ---@type Dictionary
    local dict = {}
    dict.id = tonumber(data["id"])
    dict.moneyType = tonumber(data["money_type"])
    dict.moneyValue = tonumber(data["money_value"])
    dict.resourceType = tonumber(data["res_type"])
    dict.resourceId = tonumber(data["res_id"])
    dict.resourceNumber = tonumber(data["res_number"])
    dict.resourceData = tonumber(data["res_data"]) or nil
    dict.limit = tonumber(data["limit"])
    self.listExchangeItem:Add(dict)
end

--- @return {id, moneyType, moneyValue, resourceType, resourceId, resourceNumber, resourceData, limit}
function BattlePassExchangeConfig:GetBattlePassFirstSkin()
    return self.listExchangeItem:Get(1)
end

function BattlePassExchangeConfig:FindItemById(itemId)
    for i = 1, self.listExchangeItem:Count() do
        if self.listExchangeItem:Get(i).id == itemId then
            return self.listExchangeItem:Get(i)
        end
    end
end

return BattlePassExchangeConfig