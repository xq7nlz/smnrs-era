
--- @class UITrainingTeamModel : UIBaseModel
UITrainingTeamModel = Class(UITrainingTeamModel, UIBaseModel)

--- @return void
function UITrainingTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITrainingTeam, "training_team")
	---@type number
	self.slotUnlock = 0
	---@type List
	self.heroResourceList = List()
	---@type List
	self.heroResourceSelect = List()

	self.bgDark = true
end

--- @return void
function UITrainingTeamModel:InitData()
	self.slotUnlock = 0
	local levelCache
	local campaignConfig = ResourceMgr.GetCampaignDataConfig().campaignConfig
	local playerLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    for i, v in pairs(campaignConfig.trainSlotIncrementLevel:GetItems()) do
		if playerLevel >= i and (levelCache == nil or levelCache < i) then
			levelCache = i
			self.slotUnlock = v
		end
	end

	--- @type VipData
	local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
	self.slotUnlock = self.slotUnlock + campaignConfig.autoTrainSlot + vip.campaignBonusAutoTrainSlot
	self.heroResourceList:Clear()
	---@param v HeroResource
	for _, v in pairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
		if v.heroStar <= campaignConfig.trainStarMax then
			self.heroResourceList:Add(v)
		end
	end
end