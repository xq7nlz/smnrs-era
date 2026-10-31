require "lua.client.scene.ui.home.uiEventBossChallenge.UIEventBossChallengeModel"
require "lua.client.scene.ui.home.uiEventBossChallenge.UIEventBossChallengeView"

--- @class UIEventBossChallenge : UIBase
UIEventBossChallenge = Class(UIEventBossChallenge, UIBase)

--- @return void
function UIEventBossChallenge:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventBossChallenge:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBossChallengeModel()
	self.view = UIEventBossChallengeView(self.model)
end

return UIEventBossChallenge
