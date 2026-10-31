local EVENT_NEW_YEAR_2023_DAILY_PURCHASE_PATH = "csv/event/event_new_year_2023/data_%d/daily_pack.csv"

--- @class NewYear2023DailyStore : EventStore
NewYear2023DailyStore = Class(NewYear2023DailyStore, EventStore)

function NewYear2023DailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR_2023
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_YEAR_2023_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_NEW_YEAR_2023_DAILY_PURCHASE_PATH
    --- @type EventNewYear2023DailyProduct
    self.pack = EventNewYear2023DailyProduct
end

--- @return boolean
function NewYear2023DailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventNewYear2023DailyProduct : EventProduct
EventNewYear2023DailyProduct = Class(EventNewYear2023DailyProduct, EventProduct)

function EventNewYear2023DailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_YEAR_2023_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR_2023
end