--- @class LimitedBundleProduct : EventProduct
LimitedBundleProduct = Class(LimitedBundleProduct, EventProduct)

function LimitedBundleProduct:Ctor()
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
    EventProduct.Ctor(self)
end

--- @return void
function LimitedBundleProduct:ParseCsv(data)
    EventProduct.ParseCsv(self, data)
    if data.selection_res_type ~= nil then
        local reward = RewardInBound.CreateBySingleParam(tonumber(data.selection_res_type), tonumber(data.selection_res_id),
                tonumber(data.selection_res_number) == nil and data.selection_res_number or tonumber(data.selection_res_number),
                data.selection_res_data)
        reward.id = tonumber(data.selection_id)
        self.rewardPool:Add(reward)
    end
end