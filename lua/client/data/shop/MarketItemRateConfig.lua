--- @class MarketItemRateConfig
MarketItemRateConfig = Class(MarketItemRateConfig)

function MarketItemRateConfig:Ctor()
    --- @type RewardInBound
    self.rewardInBound = RewardInBound()
    --- @type number
    self.rate = nil
    --- @type number
    self.stock = nil
    --- @type number
    self.numberItemCanBuy = nil
    --- @type number
    self.moneyType = nil
    --- @type number
    self.moneyValue = nil
end

--- @param itemTable {res_type, res_id, res_number, res_data, rate, stock, number_item_can_buy, money_type, money_value}
function MarketItemRateConfig:SetDataTable(itemTable)
    self.rewardInBound = RewardInBound.CreateBySingleParam(itemTable.res_type,
            itemTable.res_id,
            itemTable.res_number,
            itemTable.res_data)
    self.rate = tonumber(itemTable.rate)
    self.stock = tonumber(itemTable.stock)
    self.numberItemCanBuy = tonumber(itemTable.number_item_can_buy)
    self.moneyType = tonumber(itemTable.money_type)
    self.moneyValue = tonumber(itemTable.money_value)
end
