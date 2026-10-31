--- @class SummonerPriceEvolveConfig
SummonerPriceEvolveConfig = Class(SummonerPriceEvolveConfig)

function SummonerPriceEvolveConfig:Ctor()
    --- @type number
    self.star = nil
    --- @type List -- <ItemIconData>
    self.listMoney = List()
    self.rewardList = List()
end

--- @data string
function SummonerPriceEvolveConfig:ParseCsv(data)
    local moneyType
    local moneyValue
    self.star = tonumber(data['star'])
    for i = 1, 4 do
        moneyType = tonumber(data['money_type_'..i])
        moneyValue = tonumber(data['money_value_'..i])
        if moneyValue ~= nil and moneyValue > 0 then
            self.listMoney:Add(ItemIconData.CreateInstance(ResourceType.Money, moneyType, moneyValue))
        end
    end
end

--- @data string
function SummonerPriceEvolveConfig:GetRewardList()
    XDebug.Log( self.listMoney:Count())
    if self.rewardList:Count() == 0 then
        for i = 1, self.listMoney:Count() do
            local reward = self.listMoney:Get(i)
            self.rewardList:Add(RewardInBound.CreateBySingleParam(reward.type, reward.itemId, reward.quantity))
        end
    end
    return self.rewardList
end