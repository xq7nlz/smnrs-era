require "lua.client.core.network.playerData.common.RewardInBound"
--- @class ZodiacExchangeItemData
ZodiacExchangeItemData = Class(ZodiacExchangeItemData)

function ZodiacExchangeItemData:Ctor()
	--- @type RewardInBound
	self.itemData = nil
	--- @type number
	self.limit = 0
	--- @type number
	self.price = 0
	--- @type number
	self.buyTime = 0
	--- @type MoneyType
	self.moneyType = 0
	--- @type number
	self.id = 0
end
--- @return ZodiacExchangeItemData
function ZodiacExchangeItemData.CreateByParams(data)
	local item = ZodiacExchangeItemData()
	item.itemData = RewardInBound.CreateByParams(data)
	item.limit = tonumber(data.limit)
	item.price = tonumber(data.money_value)
	item.moneyType = tonumber(data.money_type)
	item.id =  tonumber(data.exchange_id)
	return item
end

