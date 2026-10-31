require "lua.client.scene.ui.home.uiDomainChallengeOver.UIDomainChallengeOverModel"
require "lua.client.scene.ui.home.uiDomainChallengeOver.UIDomainChallengeOverView"

--- @class UIDomainChallengeOver : UIBase
UIDomainChallengeOver = Class(UIDomainChallengeOver, UIBase)

--- @return void
function UIDomainChallengeOver:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainChallengeOver:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainChallengeOverModel()
	self.view = UIDomainChallengeOverView(self.model)
end

return UIDomainChallengeOver
