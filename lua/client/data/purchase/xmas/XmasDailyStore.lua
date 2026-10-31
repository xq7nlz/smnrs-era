local EVENT_DAILY_PURCHASE_PATH = "csv/event/event_christmas/data_%d/daily_pack.csv"

--- @class XmasDailyStore : EventStore
XmasDailyStore = Class(XmasDailyStore, EventStore)

function XmasDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_XMAS
    --- @type OpCode
    self.opCode = OpCode.EVENT_CHRISTMAS_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_DAILY_PURCHASE_PATH
    --- @type EventXmasDailyProduct
    self.pack = EventXmasDailyProduct
end

--- @return boolean
function XmasDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventXmasModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventXmasDailyProduct : EventProduct
EventXmasDailyProduct = Class(EventXmasDailyProduct, EventProduct)

function EventXmasDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_CHRISTMAS_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_XMAS
end