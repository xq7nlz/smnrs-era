--- @class LimitedProduct : ProductConfig
LimitedProduct = Class(LimitedProduct, ProductConfig)

function LimitedProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_LIMITED_PACK
    self.isLimited = true
end

--- @return void
function LimitedProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.stock = tonumber(data['stock'])
        --- @type number
        self.resetType = tonumber(data['reset_type'])
    end
    self.rewardList:Add(RewardInBound.CreateByParams(data))
end