require "lua.client.scene.ui.home.uiTutorial.UITutorialModel"
require "lua.client.scene.ui.home.uiTutorial.UITutorialView"

--- @class uiTutorial : UIBase
UITutorial = Class(UITutorial, UIBase)

--- @return void
function UITutorial:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITutorial:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITutorialModel()
	self.view = UITutorialView(self.model, self.ctrl)
end

return UITutorial
