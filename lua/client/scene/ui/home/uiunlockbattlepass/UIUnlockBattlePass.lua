require "lua.client.scene.ui.home.uiUnlockBattlePass.UIUnlockBattlePassModel"
require "lua.client.scene.ui.home.uiUnlockBattlePass.UIUnlockBattlePassView"

--- @class UIUnlockBattlePass : UIBase
UIUnlockBattlePass = Class(UIUnlockBattlePass, UIBase)

--- @return void
function UIUnlockBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUnlockBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUnlockBattlePassModel()
	self.view = UIUnlockBattlePassView(self.model)
end

return UIUnlockBattlePass
