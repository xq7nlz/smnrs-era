
--- @class TowerDefenseLevelConfig
TowerDefenseLevelConfig = Class(TowerDefenseLevelConfig)

function TowerDefenseLevelConfig:Ctor(parsedData)
    ---@type number
    self.level = tonumber(parsedData.level)
    ---@type List  --<RewardInBound>
    self.listMoney = List()
end

function TowerDefenseLevelConfig:AddMoney(parsedData)
    if parsedData.money_type ~= nil and parsedData.money_type ~= "" then
        self.listMoney:Add(RewardInBound.CreateBySingleParam(ResourceType.Money,
                tonumber(parsedData.money_type), tonumber(parsedData.money_value)))
    end
end