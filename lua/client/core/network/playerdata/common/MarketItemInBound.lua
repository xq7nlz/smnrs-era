--- @class MarketItemInBound
MarketItemInBound = Class(MarketItemInBound)

--- @return void
function MarketItemInBound:Ctor()
    --- @type number
    self.id = nil
    --- @type DynamicRewardInBound
    self.reward = nil
    --- @type CostInBound
    self.cost = nil
    --- @type number
    self.numberItemCanBuy = nil
    --- @type number
    self.maxItem = nil
end

function MarketItemInBound:CanBuy()
    return self.numberItemCanBuy > 0
end

--- @return string
function MarketItemInBound:ToString()
    return string.format("id[%d] reward[%s] cost[%s] numberItemCanBy[%d]", self.id, self.reward:ToString(), self.cost:ToString(), self.numberItemCanBuy)
end

--- @return MarketItemInBound
--- @param buffer UnifiedNetwork_ByteBuf
function MarketItemInBound.CreateByBuffer(buffer)
    local data = MarketItemInBound()
    data.id = buffer:GetByte()
    data.reward = DynamicRewardInBound.CreateByBuffer(buffer)
    data.cost = CostInBound.CreateByBuffer(buffer)
    data.numberItemCanBuy = buffer:GetByte()
    data.maxItem = buffer:GetByte()
    return data
end

--- @return MarketItemInBound
function MarketItemInBound.CreateByJson(json)
    local data = MarketItemInBound()

    data.id = json['0']
    data.reward = DynamicRewardInBound.CreateByJson(json['1'])
    data.cost = CostInBound.CreateByJson(json['2'])
    data.numberItemCanBuy = json['3']

    return data
end
