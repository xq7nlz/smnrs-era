
--- @class UIUnlockBattlePassModel : UIBaseModel
UIUnlockBattlePassModel = Class(UIUnlockBattlePassModel, UIBaseModel)

--- @return void
function UIUnlockBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUnlockBattlePass, "unlock_battle_pass")

	self.bgDark = true
end

