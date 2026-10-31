--- @class ProductCheckItemInBound
ProductCheckItemInBound = Class(ProductCheckItemInBound)

function ProductCheckItemInBound:Ctor(buffer)
    self:ReadBuffer(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function ProductCheckItemInBound:ReadBuffer(buffer)
    self.deviceOs = buffer:GetByte()
    self.productId = buffer:GetString(false)
    self.isPurchased = buffer:GetBool()
end