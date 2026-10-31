--- @class UIPopupSplitRewardModel : UIBaseModel
UIPopupSplitRewardModel = Class(UIPopupSplitRewardModel, UIBaseModel)

--- @return void
function UIPopupSplitRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupSplitReward, "popup_split_reward")

	--- @type List <ItemIconData>
	self.resourceList = List()

	self.bgDark = true
end

