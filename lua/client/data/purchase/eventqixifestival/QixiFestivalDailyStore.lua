local EVENT_QIXI_DAILY_PURCHASE_PATH = "csv/event/event_qixi/data_%d/daily_pack.csv"

--- @class QixiFestivalDailyStore : EventStore
QixiFestivalDailyStore = Class(QixiFestivalDailyStore, EventStore)

function QixiFestivalDailyStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_QIXI
    --- @type OpCode
    self.opCode = OpCode.EVENT_QIXI_DAILY_PURCHASE
    --- @type string
    self.filePath = EVENT_QIXI_DAILY_PURCHASE_PATH
    --- @type EventQixiFestivalDailyProduct
    self.pack = EventQixiFestivalDailyProduct
end

--- @return boolean
function QixiFestivalDailyStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end

--- @class EventQixiFestivalDailyProduct : EventProduct
EventQixiFestivalDailyProduct = Class(EventQixiFestivalDailyProduct, EventProduct)

function EventQixiFestivalDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_QIXI_DAILY_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_QIXI
end