require "lua.client.data.CampaignData.ProductionCampaign"

--- @class UISelectMapPVEModel : UIBaseModel
UISelectMapPVEModel = Class(UISelectMapPVEModel, UIBaseModel)

--- @return void
function UISelectMapPVEModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectMapPVE, "select_map_pve")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	----@type number
	self.timeRewardItem = 30
	---@type number
	self.difficultId = 1
	--- @type number
	self.mapId = 1
	---@type boolean
	self.canClaimMoney = false
	---@type boolean
	self.canLootItem = false
	--- @type number
	self.gold = 0
	--- @type number
	self.magicPotion = 0
	--- @type number
	self.exp = 0
	--- @type number
	self.timeIdleCurrentStageMoney = 0
	--- @type number
	self.timeIdleCurrentStageItem = 0

	self.bgDark = false
end