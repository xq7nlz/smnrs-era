require "lua.client.scene.ui.home.uiEventHeroRelease.UIEventHeroReleaseModel"
require "lua.client.scene.ui.home.uiEventHeroRelease.UIEventHeroReleaseView"

--- @class UIEventHeroRelease : UIBase
UIEventHeroRelease = Class(UIEventHeroRelease, UIBase)

--- @return void
function UIEventHeroRelease:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventHeroRelease:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventHeroReleaseModel()
	self.view = UIEventHeroReleaseView(self.model)
end

return UIEventHeroRelease
