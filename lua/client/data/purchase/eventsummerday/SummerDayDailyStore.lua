local EVENT_SUMMER_DAY_DAILY_PURCHASE_PATH = "csv/event/event_summer_day/data_%d/daily_pack.csv"

--- @class SummerDayDailyStore : EventStore
SummerDayDailyStore = Class(SummerDayDailyStore, EventStore)

function SummerDayDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SUMMER_DAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_SUMMER_DAY_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_SUMMER_DAY_DAILY_PURCHASE_PATH
    --- @type EventSummerDayProduct
    self.pack = EventSummerDayProduct
end

--- @return boolean
function SummerDayDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventSummerDayDailyProduct : EventProduct
EventSummerDayDailyProduct = Class(EventSummerDayDailyProduct, EventProduct)

function EventSummerDayDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SUMMER_DAY_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_SUMMER_DAY
end