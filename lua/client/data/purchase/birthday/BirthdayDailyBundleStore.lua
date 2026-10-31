local EVENT_BIRTHDAY_DAILY_PURCHASE_PATH = "csv/event/event_birthday/data_%d/daily_pack.csv"

--- @class BirthdayDailyBundleStore : EventStore
BirthdayDailyBundleStore = Class(BirthdayDailyBundleStore, EventStore)

function BirthdayDailyBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BIRTHDAY_DAILY_PURCHASE_PATH
    --- @type BirthdayDailyProduct
    self.pack = BirthdayDailyProduct
end

--- @return boolean
function BirthdayDailyBundleStore:IsNotificationDailyDeal()
    local notify = false
    ---@type EventBirthdayModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    --- @param v LimitedProduct
    for _, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and eventBirthdayModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            notify = true
            break
        end
    end
    return notify
end

--- @class BirthdayDailyProduct : EventProduct
BirthdayDailyProduct = Class(BirthdayDailyProduct, EventProduct)

function BirthdayDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
end