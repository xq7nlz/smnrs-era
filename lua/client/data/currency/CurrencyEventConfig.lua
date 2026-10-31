--- @class CurrencyEventConfig
CurrencyEventConfig = Class(CurrencyEventConfig)

--- @return void
function CurrencyEventConfig:Ctor()
    ---@type List
    self.list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/client/money_event.csv")
    for i = 1, #parsedData do
        local data = {}
        data.id = tonumber(parsedData[i].id)
        data.eventType = tonumber(parsedData[i].event_type)
        data.dataId = tonumber(parsedData[i].data)
        self.list:Add(data)
    end
end

--- @return List
function CurrencyEventConfig:GetListCurrencyIgnore()
    local listIgnoreBuyEvent = List()
    --- @param v {id, eventType : EventTimeType, dataId}
    for _, v in pairs(self.list:GetItems()) do
        if EventInBound.IsEventOpening(v.eventType, v.dataId) == false then
            listIgnoreBuyEvent:Add(v.id)
        end
    end
    return listIgnoreBuyEvent
end

return CurrencyEventConfig