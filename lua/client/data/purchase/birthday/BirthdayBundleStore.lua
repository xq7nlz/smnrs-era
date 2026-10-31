local EVENT_BIRTHDAY_BUNDLE_PURCHASE_PATH = "csv/event/event_birthday/data_%d/bundle/birthday_bundle.csv"

--- @class BirthdayBundleStore : EventStore
BirthdayBundleStore = Class(BirthdayBundleStore, EventStore)

function BirthdayBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BIRTHDAY_BUNDLE_PURCHASE_PATH
    --- @type BirthdayBundleProduct
    self.pack = BirthdayBundleProduct
end

--- @class BirthdayBundleProduct : EventProduct
BirthdayBundleProduct = Class(BirthdayBundleProduct, EventProduct)

function BirthdayBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
end