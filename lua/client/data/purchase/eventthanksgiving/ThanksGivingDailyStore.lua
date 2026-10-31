local EVENT_THANKS_GIVING_DAILY_PURCHASE_PATH = "csv/event/event_thanks_giving/data_%d/daily_pack.csv"

--- @class ThanksGivingDailyStore : EventStore
ThanksGivingDailyStore = Class(ThanksGivingDailyStore, EventStore)

function ThanksGivingDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_THANKS_GIVING
    --- @type OpCode
    self.opCode = OpCode.EVENT_THANKS_GIVING_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_THANKS_GIVING_DAILY_PURCHASE_PATH
    --- @type EventHalloweenProduct
    self.pack = EventHalloweenProduct
end

--- @return boolean
function ThanksGivingDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventThanksGivingDailyProduct : EventProduct
EventThanksGivingDailyProduct = Class(EventThanksGivingDailyProduct, EventProduct)

function EventThanksGivingDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_THANKS_GIVING_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_THANKS_GIVING
end