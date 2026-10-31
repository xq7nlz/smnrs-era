
--- @class MainConstructionLevelConfig
MainConstructionLevelConfig = Class(MainConstructionLevelConfig)

function MainConstructionLevelConfig:Ctor(parsedData)
    ---@type number
    self.level = tonumber(parsedData.level)
    ---@type number
    self.hp = tonumber(parsedData.hp)
    ---@type List  --<RewardInBound>
    self.listMoney = List()
end

function MainConstructionLevelConfig:AddMoney(parsedData)
    self.listMoney:Add(RewardInBound.CreateBySingleParam(ResourceType.Money,
            tonumber(parsedData.money_type), tonumber(parsedData.money_value)))
end