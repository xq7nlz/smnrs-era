require "lua.client.scene.ui.home.uiWheelOfFate.UIWheelOfFateModel"
require "lua.client.scene.ui.home.uiWheelOfFate.UIWheelOfFateView"
require "lua.client.scene.ui.home.uiWheelOfFate.UIWheelOfFateCtrl"

--- @class UIWheelOfFate : UIBase
UIWheelOfFate = Class(UIWheelOfFate, UIBase)

--- @return void
function UIWheelOfFate:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWheelOfFate:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWheelOfFateModel()
	self.ctrl = UIWheelOfFateCtrl(self.model)
	self.view = UIWheelOfFateView(self.model, self.ctrl)
end

--- @return UIWheelOfFate
function UIWheelOfFate.CreateInstance()
	return UIWheelOfFate()
end

return UIWheelOfFate
