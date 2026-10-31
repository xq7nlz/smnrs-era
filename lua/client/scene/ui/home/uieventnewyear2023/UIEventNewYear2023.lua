require "lua.client.scene.ui.home.uiEventNewYear2023.UIEventNewYear2023Model"
require "lua.client.scene.ui.home.uiEventNewYear2023.UIEventNewYear2023View"

--- @class UIEventNewYear2023 : UIBase
UIEventNewYear2023 = Class(UIEventNewYear2023, UIBase)

--- @return void
function UIEventNewYear2023:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventNewYear2023:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventNewYear2023Model()
	self.view = UIEventNewYear2023View(self.model)
end

return UIEventNewYear2023
