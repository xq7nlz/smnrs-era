require "lua.client.scene.ui.home.uiEventZodiac.UIEventZodiacModel"
require "lua.client.scene.ui.home.uiEventZodiac.UIEventZodiacView"

--- @class UIEventZodiac : UIBase
UIEventZodiac = Class(UIEventZodiac, UIBase)

--- @return void
function UIEventZodiac:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventZodiac:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventZodiacModel()
	self.view = UIEventZodiacView(self.model)
end

return UIEventZodiac
