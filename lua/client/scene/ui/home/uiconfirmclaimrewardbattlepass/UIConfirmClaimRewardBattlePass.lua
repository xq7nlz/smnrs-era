require "lua.client.scene.ui.home.uiConfirmClaimRewardBattlePass.UIConfirmClaimRewardBattlePassModel"
require "lua.client.scene.ui.home.uiConfirmClaimRewardBattlePass.UIConfirmClaimRewardBattlePassView"

--- @class UIConfirmClaimRewardBattlePass : UIBase
UIConfirmClaimRewardBattlePass = Class(UIConfirmClaimRewardBattlePass, UIBase)

--- @return void
function UIConfirmClaimRewardBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIConfirmClaimRewardBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIConfirmClaimRewardBattlePassModel()
	self.view = UIConfirmClaimRewardBattlePassView(self.model)
end

return UIConfirmClaimRewardBattlePass
