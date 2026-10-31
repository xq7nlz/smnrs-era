--- @class ServerOpenMarket
ServerOpenMarket = Class(ServerOpenMarket)

--- @return void
function ServerOpenMarket:Ctor()
    self.stock = nil
    self.id = nil
    self.vipRequire = nil
    ---@type ItemIconData
    self.moneyData = List()
    ---@type List --<RewardInBound>
    self.listReward = List()
end

--- @return void
function ServerOpenMarket:ParsedData(data)
    self.id = tonumber(data.id)
    self.stock = tonumber(data.stock)
    self.vipRequire = tonumber(data.vip_required)
    self.moneyData = ItemIconData.CreateInstance(ResourceType.Money, tonumber(data.money_type), tonumber(data.money_value))
    self:AddData(data)
end

--- @return void
function ServerOpenMarket:AddData(data)
    if data.res_type ~= nil then
        self.listReward:Add(RewardInBound.CreateByParams(data))
    end
end