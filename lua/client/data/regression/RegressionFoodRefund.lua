require("lua.client.data.HeroMenu.HeroEvolvePriceConfig")

--- @class RegressionFoodRefund
RegressionFoodRefund = Class(RegressionFoodRefund)

function RegressionFoodRefund:Ctor(data)
    ---@type number
    self.star = nil
    ---@type List --<HeroMaterialEvolveData>
    self.listFood = nil

    if data ~= nil then
        self:ParseCsv(data)
    end
end

function RegressionFoodRefund:ParseCsv(data)
    self.star = tonumber(data.star)
    self.listFood = List()
    self:AddData(data)
end

function RegressionFoodRefund:AddData(data)
    self.listFood:Add(HeroMaterialEvolveData(tonumber(data.food_id), tonumber(data.food_star), tonumber(data.food_number)))
end