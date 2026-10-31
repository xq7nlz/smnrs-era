--- @class ProductCheckItemOutBound
ProductCheckItemOutBound = Class(ProductCheckItemOutBound)

function ProductCheckItemOutBound:Ctor(deviceOs, productId)
    self.deviceOs = deviceOs
    self.productId = productId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ProductCheckItemOutBound:Serialize(buffer)
    buffer:PutByte(self.deviceOs)
    buffer:PutString(self.productId, false)
end