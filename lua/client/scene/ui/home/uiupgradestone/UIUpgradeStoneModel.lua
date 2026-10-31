
--- @class UIUpgradeStoneModel : UIBaseModel
UIUpgradeStoneModel = Class(UIUpgradeStoneModel, UIBaseModel)

--- @return void
function UIUpgradeStoneModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUpgradeStone, "upgrade_stone")
	---@type HeroResource
	self.heroResource = nil
	self.stoneId = nil
	self.upgrade = nil
	self.isKeepProperty = false
	---@type StoneCostConfig
	self.stoneCostConfig = nil
	---@type StoneDataConfig
	self.stoneData = nil

	self.rewardList = List()

	self.bgDark = true
end
--- @return boolean
function UIUpgradeStoneModel:UpdateRewardListForUpgrade()
	self.rewardList:Clear()
	self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, self.stoneCostConfig.upgradeGold))
	self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.STONE_DUST, self.stoneCostConfig.upgradeDust))
	if self.isKeepProperty then
		self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, self.stoneCostConfig.keepProperty))
	end
end
--- @return boolean
function UIUpgradeStoneModel:UseResourceUpgrade()
	self:UpdateRewardListForUpgrade()
	local canUpgrade = InventoryUtils.IsEnoughMultiResourceRequirement(self.rewardList)
	if canUpgrade then
		InventoryUtils.Sub(ResourceType.Money, MoneyType.GOLD, self.stoneCostConfig.upgradeGold)
		InventoryUtils.Sub(ResourceType.Money, MoneyType.STONE_DUST, self.stoneCostConfig.upgradeDust)
		if self.isKeepProperty == true then
			InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, self.stoneCostConfig.keepProperty)
		end
		return true
	end
end