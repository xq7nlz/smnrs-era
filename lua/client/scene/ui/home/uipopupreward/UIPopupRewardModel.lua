
--- @class UIPopupRewardModel : UIBaseModel
UIPopupRewardModel = Class(UIPopupRewardModel, UIBaseModel)

--- @return void
function UIPopupRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupReward, "popup_reward")

	--- @type List <ItemIconData>
	self.resourceList = List()

	self.bgDark = true
end

