
--- @class UIPreviewRewardBattlePassModel : UIBaseModel
UIPreviewRewardBattlePassModel = Class(UIPreviewRewardBattlePassModel, UIBaseModel)

--- @return void
function UIPreviewRewardBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewRewardBattlePass, "preview_reward_battle_pass")

	self.bgDark = true
end

