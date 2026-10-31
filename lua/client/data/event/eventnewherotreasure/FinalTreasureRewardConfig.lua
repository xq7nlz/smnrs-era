--- @class FinalTreasureRewardConfig
FinalTreasureRewardConfig = Class(FinalTreasureRewardConfig)

function FinalTreasureRewardConfig:Ctor(parsedData)
    ---@type number
    self.id = tonumber(parsedData.id)
    ---@type number
    self.moneyType = tonumber(parsedData.money_type)
    ---@type number
    self.moneyValue = tonumber(parsedData.money_value)
    ---@type List
    self.listReward = nil
    self:AddReward(parsedData)
end

function FinalTreasureRewardConfig:AddReward(parsedData)
    if self.listReward == nil then
        ---@type List
        self.listReward = List()
    end
    self.listReward:Add(RewardInBound.CreateByParams(parsedData))
end