require "lua.client.core.network.iap.ProductCheckItemOutBound"
require "lua.client.core.network.iap.ProductCheckInBound"

--- @class ProductCheckOutBound : OutBound
ProductCheckOutBound = Class(ProductCheckOutBound, OutBound)

function ProductCheckOutBound:Ctor()
    self.listItemOutBound = List()
end

--- @param productCheckItemOutBound ProductCheckItemOutBound
function ProductCheckOutBound:AddItem(productCheckItemOutBound)
    self.listItemOutBound:Add(productCheckItemOutBound)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ProductCheckOutBound:Serialize(buffer)
    buffer:PutByte(self.listItemOutBound:Count())
    for i = 1, self.listItemOutBound:Count() do
        self.listItemOutBound:Get(i):Serialize(buffer)
    end
end

--- @param listProductId List
function ProductCheckOutBound.CheckPurchaseProduct(listProductId, onSuccess, onFailed, showWaiting)
    local deviceOs = ClientConfigUtils.GetDeviceOS()
    local productCheckOutBound = ProductCheckOutBound()
    for i = 1, listProductId:Count() do
        productCheckOutBound:AddItem(ProductCheckItemOutBound(deviceOs, listProductId:Get(i)))
    end

    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local value = ProductCheckInBound()
            value:ReadBuffer(buffer)
            onSuccess(value)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, nil, onFailed)
    end
    NetworkUtils.Request(OpCode.PURCHASE_PRODUCT_CHECK, productCheckOutBound, onReceived, showWaiting)
end