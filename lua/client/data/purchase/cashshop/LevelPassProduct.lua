--- @class LevelPassProduct : ProductConfig
LevelPassProduct = Class(LevelPassProduct, ProductConfig)

function LevelPassProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_GROWTH_PACK
end

--- @return void
function LevelPassProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.duration = tonumber(data['duration'])
        --- @type number
        self.conditionType = tonumber(data['condition_type'])
        --- @type number
        self.conditionValue = tonumber(data['condition_value'])
        --- @type number
        self.profit = tonumber(data['profit'])
        --- @type number
        self.stock = tonumber(data['stock'])
    end
    self.rewardList:Add(RewardInBound.CreateByParams(data))
end