require "lua.client.scene.ui.home.uiEventBossChallengeFormation.UIEventBossChallengeFormationModel"
require "lua.client.scene.ui.home.uiEventBossChallengeFormation.UIEventBossChallengeFormationView"

--- @class UIEventBossChallengeFormation : UIBase
UIEventBossChallengeFormation = Class(UIEventBossChallengeFormation, UIBase)

--- @return void
function UIEventBossChallengeFormation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventBossChallengeFormation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBossChallengeFormationModel()
	self.view = UIEventBossChallengeFormationView(self.model)
end

return UIEventBossChallengeFormation
