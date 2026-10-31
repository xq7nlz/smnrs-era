
--- @class UIPopupPurchaseLevelBattlePassModel : UIBaseModel
UIPopupPurchaseLevelBattlePassModel = Class(UIPopupPurchaseLevelBattlePassModel, UIBaseModel)

--- @return void
function UIPopupPurchaseLevelBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupPurchaseLevelBattlePass, "popup_purchase_level_battle_pass")

	self.bgDark = true
end

