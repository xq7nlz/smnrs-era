--- @class ServerOpenProgress
ServerOpenProgress = Class(ServerOpenProgress)

--- @return void
function ServerOpenProgress:Ctor()
    self.id = nil
    ---@type ItemIconData
    self.moneyData = List()
    ---@type List --<RewardInBound>
    self.listReward = List()
end

--- @return void
function ServerOpenProgress:ParsedData(data)
    self.id = tonumber(data.id)
    self.moneyData = ItemIconData.CreateInstance(ResourceType.Money, tonumber(data.progress_money_type), tonumber(data.progress_money_value))
    self:AddData(data)
end

--- @return void
function ServerOpenProgress:AddData(data)
    if data.res_type ~= nil then
        self.listReward:Add(RewardInBound.CreateByParams(data))
    end
end