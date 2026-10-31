local EVENT_HALLOWEEN_DAILY_PURCHASE_PATH = "csv/event/event_halloween/data_%d/daily_pack.csv"

--- @class HalloweenDailyStore : EventStore
HalloweenDailyStore = Class(HalloweenDailyStore, EventStore)

function HalloweenDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_HALLOWEEN
    --- @type OpCode
    self.opCode = OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_HALLOWEEN_DAILY_PURCHASE_PATH
    --- @type EventHalloweenProduct
    self.pack = EventHalloweenProduct
end

--- @return boolean
function HalloweenDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventHalloweenModel
    local eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventHalloweenModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventHalloweenDailyProduct : EventProduct
EventHalloweenDailyProduct = Class(EventHalloweenDailyProduct, EventProduct)

function EventHalloweenDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_HALLOWEEN
end