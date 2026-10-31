require "lua.client.scene.ui.home.uiPreviewRewardBattlePass.UIPreviewRewardBattlePassModel"
require "lua.client.scene.ui.home.uiPreviewRewardBattlePass.UIPreviewRewardBattlePassView"

--- @class UIPreviewRewardBattlePass : UIBase
UIPreviewRewardBattlePass = Class(UIPreviewRewardBattlePass, UIBase)

--- @return void
function UIPreviewRewardBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewRewardBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewRewardBattlePassModel()
	self.view = UIPreviewRewardBattlePassView(self.model)
end

return UIPreviewRewardBattlePass
