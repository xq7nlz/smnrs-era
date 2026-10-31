
--- @class UIStageSelectModel : UIBaseModel
UIStageSelectModel = Class(UIStageSelectModel, UIBaseModel)

--- @return void
function UIStageSelectModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIStageSelect, "stage_select")
	---@type number
	self.difficult = nil
	---@type number
	self.map = nil
	---@type number
	self.stage = nil
	---@type number
	self.stageId = nil
	--- @type List --<ItemIconData>
	self.resourceList = nil

	self.bgDark = true
end

--- @return void
function UIStageSelectModel:UpdateData()
	self.difficult, self.map, self.stage = ClientConfigUtils.GetIdFromStageId(self.stageId)
	if self.resourceList == nil then
		self.resourceList = ResourceMgr.GetIdleRewardConfig():GetRewardsIdle(self.stageId)
	end
end

