
--- @class UIRewardLevelUpBeastModel : UIBaseModel
UIRewardLevelUpBeastModel = Class(UIRewardLevelUpBeastModel, UIBaseModel)

--- @return void
function UIRewardLevelUpBeastModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRewardLevelUpBeast, "ui_reward_level_up_beast")
	self.bgDark = true
end

