require "lua.client.scene.ui.home.uiPopupPurchaseLevelBattlePass.UIPopupPurchaseLevelBattlePassModel"
require "lua.client.scene.ui.home.uiPopupPurchaseLevelBattlePass.UIPopupPurchaseLevelBattlePassView"

--- @class UIPopupPurchaseLevelBattlePass : UIBase
UIPopupPurchaseLevelBattlePass = Class(UIPopupPurchaseLevelBattlePass, UIBase)

--- @return void
function UIPopupPurchaseLevelBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupPurchaseLevelBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupPurchaseLevelBattlePassModel()
	self.view = UIPopupPurchaseLevelBattlePassView(self.model)
end

return UIPopupPurchaseLevelBattlePass
