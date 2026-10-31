--- @class EventProduct : ProductConfig
EventProduct = Class(EventProduct, ProductConfig)

function EventProduct:Ctor()
    ProductConfig.Ctor(self)
    self.isLimited = true
    self.boughtPacks = 0
    --- @type EventTimeType
    self.eventTimeType = nil
end

--- @return void
function EventProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.stock = tonumber(data['stock'])
    end
    if data.res_type ~= nil then
        self.rewardList:Add(RewardInBound.CreateByParams(data))
    end
end