
--- @class UIPopupRewardArenaModel : UIBaseModel
UIPopupRewardArenaModel = Class(UIPopupRewardArenaModel, UIBaseModel)

--- @return void
function UIPopupRewardArenaModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupRewardArena, "popup_reward_arena")

	self.bgDark = true
end

