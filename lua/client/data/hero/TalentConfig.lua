--- @class TalentConfig
TalentConfig = Class(TalentConfig)
function TalentConfig:Ctor(data)
	--- @type number
	self.slot = nil
	--- @type number
	self.resetMoneyType = nil
	---@type number
	self.moneyReset = nil
	--- @type number
	self.moneyRefreshType = nil
	---@type number
	self.moneyRefresh = nil
	---@type number
	self.poolNumberItem = nil
	---@type ItemIconData
	self.refreshMoneyData = nil
	---@type ItemIconData
	self.resetMoneyData = nil

	self:SetData(data)
end




function TalentConfig:SetData(data)
	self.slot = tonumber(data.slot)
	self.resetMoneyType = tonumber(data.reset_money_type)
	self.moneyReset = tonumber(data.reset_money_value)
	self.moneyRefreshType = tonumber(data.refresh_money_type)
	self.moneyRefresh = tonumber(data.refresh_money_value)
	self.poolNumberItem = tonumber(data.pool_number_item)
	self.refreshMoneyData = ItemIconData.CreateInstance(ResourceType.Money, self.moneyRefreshType,self.moneyRefresh)
	self.resetMoneyData = ItemIconData.CreateInstance(ResourceType.Money, self.resetMoneyType,self.moneyReset)
end
