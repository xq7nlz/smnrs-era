--- @class RegressionPrice
RegressionPrice = Class(RegressionPrice)

function RegressionPrice:Ctor(data)
    ---@type number
    self.star = nil
    ---@type List
    self.listMoney = nil

    if data ~= nil then
        self:ParseCsv(data)
    end
end

function RegressionPrice:ParseCsv(data)
    self.star = tonumber(data.star)
    self.listMoney = List()
    self:AddData(data)
end

function RegressionPrice:AddData(data)
    self.listMoney:Add(ItemIconData.CreateInstance(ResourceType.Money, tonumber(data.money_type), tonumber(data.money_value)))
end