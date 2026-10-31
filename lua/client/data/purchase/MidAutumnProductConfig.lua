--- @class MidAutumnProductConfig : ProductConfig
MidAutumnProductConfig = Class(MidAutumnProductConfig, ProductConfig)

--- @return void
function MidAutumnProductConfig:Ctor()
    --- @type number
    self.id = nil
    --- @type number
    self.dataId = nil -- use when the same opCode but can config others data
    --- @type OpCode
    self.opCode = OpCode.EVENT_MID_AUTUMN_PURCHASE
    --- @type string
    self.productID = nil
    --- @type number
    self.stock = nil
    --- @type number
    self.originalPackId = nil
    --- @type number
    self.dollarPrice = nil
end
