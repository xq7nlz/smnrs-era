--- @class UIPopupManyManyRewardModel : UIBaseModel
UIPopupManyManyRewardModel = Class(UIPopupManyManyRewardModel, UIBaseModel)

--- @return void
function UIPopupManyManyRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupManyManyReward, "popup_many_many_reward")

	--- @type List <ItemIconData>
	self.resourceList = List()

	self.bgDark = true
end

