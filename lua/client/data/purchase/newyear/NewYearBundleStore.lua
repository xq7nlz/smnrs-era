local EVENT_NEW_YEAR_PURCHASE_PATH = "csv/event/event_new_year/data_%d/bundle_pack.csv"

--- @class NewYearBundleStore : EventStore
NewYearBundleStore = Class(NewYearBundleStore, EventStore)

function NewYearBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_YEAR_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_NEW_YEAR_PURCHASE_PATH
    --- @type EventNewYearBundleProduct
    self.pack = EventNewYearBundleProduct
end

--- @return boolean
function NewYearBundleStore:IsNotificationDailyDeal()
    --local notify = false
    -----@type EventNewYearModel
    --local eventNewYearModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    ----- @param v LimitedProduct
    --for _, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
    --    if v.isFree == true and eventNewYearModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBoughtWithPackId(v.id) < v.stock then
    --        notify = true
    --        break
    --    end
    --end
    --return notify
end

--- @class EventNewYearBundleProduct : EventProduct
EventNewYearBundleProduct = Class(EventNewYearBundleProduct, EventProduct)

function EventNewYearBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_YEAR_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR
end