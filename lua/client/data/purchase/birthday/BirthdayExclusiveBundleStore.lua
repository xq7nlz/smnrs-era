local EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE_PATH = "csv/event/event_birthday/data_%d/bundle/exclusive_bundle.csv"

--- @class BirthdayExclusiveBundleStore : EventStore
BirthdayExclusiveBundleStore = Class(BirthdayExclusiveBundleStore, EventStore)

function BirthdayExclusiveBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE_PATH
    --- @type BirthdayExclusiveBundleProduct
    self.pack = BirthdayExclusiveBundleProduct
end

--- @class BirthdayExclusiveBundleProduct : EventProduct
BirthdayExclusiveBundleProduct = Class(BirthdayExclusiveBundleProduct, EventProduct)

function BirthdayExclusiveBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
end