require "lua.client.core.network.iap.ProductCheckItemInBound"

--- @class ProductCheckInBound
ProductCheckInBound = Class(ProductCheckInBound)

function ProductCheckInBound:Ctor()
    --- @type List
    self.listCheckItemInBound = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function ProductCheckInBound:ReadBuffer(buffer)
    self.listCheckItemInBound = NetworkUtils.GetListDataInBound(buffer, ProductCheckItemInBound)
end