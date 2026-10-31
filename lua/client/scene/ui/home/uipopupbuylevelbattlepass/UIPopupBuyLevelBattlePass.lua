require "lua.client.scene.ui.home.uiPopupBuyLevelBattlePass.UIPopupBuyLevelBattlePassModel"
require "lua.client.scene.ui.home.uiPopupBuyLevelBattlePass.UIPopupBuyLevelBattlePassView"

--- @class UIPopupBuyLevelBattlePass : UIBase
UIPopupBuyLevelBattlePass = Class(UIPopupBuyLevelBattlePass, UIBase)

--- @return void
function UIPopupBuyLevelBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupBuyLevelBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupBuyLevelBattlePassModel()
	self.view = UIPopupBuyLevelBattlePassView(self.model)
end

return UIPopupBuyLevelBattlePass
