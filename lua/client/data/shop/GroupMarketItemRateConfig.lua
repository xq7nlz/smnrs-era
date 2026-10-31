--- @class GroupMarketItemRateConfig
GroupMarketItemRateConfig = Class(GroupMarketItemRateConfig)

function GroupMarketItemRateConfig:Ctor()
    --- @type number
    self.groupNumber = nil
    --- @type List
    self.listMarketItemRate = List()
    --- @type RewardInBound
    self.resInbound = nil
end

--- @param itemTable {res_type, res_id, res_number, res_data, rate, stock, number_item_can_buy, money_type, money_value}
function GroupMarketItemRateConfig:AddItemData(itemTable)
    local marketItemRateConfig = MarketItemRateConfig()
    marketItemRateConfig:SetDataTable(itemTable)
    self.listMarketItemRate:Add(marketItemRateConfig)
end