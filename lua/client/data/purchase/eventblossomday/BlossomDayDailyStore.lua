local EVENT_BLOSSOM_DAY_DAILY_PURCHASE_PATH = "csv/event/event_blossom_day/data_%d/daily_pack.csv"

--- @class BlossomDayDailyStore : EventStore
BlossomDayDailyStore = Class(BlossomDayDailyStore, EventStore)

function BlossomDayDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLOSSOM
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLOSSOM_DAY_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_BLOSSOM_DAY_DAILY_PURCHASE_PATH
    --- @type EventBlossomDayDailyProduct
    self.pack = EventBlossomDayDailyProduct
end

--- @return boolean
function BlossomDayDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventBlossomDayDailyProduct : EventProduct
EventBlossomDayDailyProduct = Class(EventBlossomDayDailyProduct, EventProduct)

function EventBlossomDayDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLOSSOM_DAY_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BLOSSOM
end