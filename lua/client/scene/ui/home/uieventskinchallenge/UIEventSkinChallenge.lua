require "lua.client.scene.ui.home.uiEventSkinChallenge.UIEventSkinChallengeModel"
require "lua.client.scene.ui.home.uiEventSkinChallenge.UIEventSkinChallengeView"

--- @class UIEventSkinChallenge : UIBase
UIEventSkinChallenge = Class(UIEventSkinChallenge, UIBase)

--- @return void
function UIEventSkinChallenge:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventSkinChallenge:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventSkinChallengeModel()
	self.view = UIEventSkinChallengeView(self.model)
end

return UIEventSkinChallenge
