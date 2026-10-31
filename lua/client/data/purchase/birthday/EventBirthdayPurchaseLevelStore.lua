local PURCHASE_PATH = "csv/event/event_birthday/data_%d/bundle/level_bundle.csv"

--- @class EventBirthdayPurchaseLevelStore : EventStore
EventBirthdayPurchaseLevelStore = Class(EventBirthdayPurchaseLevelStore, EventStore)

function EventBirthdayPurchaseLevelStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTH_DAY_LEVEL_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PURCHASE_PATH
    --- @type BirthdayPurchaseLevelProduct
    self.pack = BirthdayPurchaseLevelProduct
end

--- @class BirthdayPurchaseLevelProduct : EventProduct
BirthdayPurchaseLevelProduct = Class(BirthdayPurchaseLevelProduct, EventProduct)

function BirthdayPurchaseLevelProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BIRTH_DAY_LEVEL_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
end