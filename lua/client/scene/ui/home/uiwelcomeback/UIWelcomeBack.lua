require "lua.client.scene.ui.home.uiWelcomeBack.UIWelcomeBackModel"
require "lua.client.scene.ui.home.uiWelcomeBack.UIWelcomeBackView"

--- @class UIWelcomeBack : UIBase
UIWelcomeBack = Class(UIWelcomeBack, UIBase)

--- @return void
function UIWelcomeBack:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWelcomeBack:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWelcomeBackModel()
	self.view = UIWelcomeBackView(self.model)
end

return UIWelcomeBack
