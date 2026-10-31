local EVENT_EASTER_DAY_DAILY_PURCHASE_PATH = "csv/event/event_easter_egg/data_%d/daily_pack.csv"

--- @class EasterDayDailyStore : EventStore
EasterDayDailyStore = Class(EasterDayDailyStore, EventStore)

function EasterDayDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_DAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_EASTERS_EGG_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_EASTER_DAY_DAILY_PURCHASE_PATH
    --- @type EventEasterDayProduct
    self.pack = EventEasterDayProduct
end

--- @return boolean
function EasterDayDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventEasterEggDailyProduct : EventProduct
EventEasterEggDailyProduct = Class(EventEasterEggDailyProduct, EventProduct)

function EventEasterEggDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_EASTERS_EGG_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_EASTER_DAY
end