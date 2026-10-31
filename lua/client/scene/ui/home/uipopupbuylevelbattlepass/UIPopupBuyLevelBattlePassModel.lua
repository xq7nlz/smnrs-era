
--- @class UIPopupBuyLevelBattlePassModel : UIBaseModel
UIPopupBuyLevelBattlePassModel = Class(UIPopupBuyLevelBattlePassModel, UIBaseModel)

--- @return void
function UIPopupBuyLevelBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupBuyLevelBattlePass, "popup_buy_level_battle_pass")

	self.bgDark = true
end