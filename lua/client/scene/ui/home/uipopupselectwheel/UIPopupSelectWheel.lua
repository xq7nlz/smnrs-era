require "lua.client.scene.ui.home.uiPopupSelectWheel.UIPopupSelectWheelModel"
require "lua.client.scene.ui.home.uiPopupSelectWheel.UIPopupSelectWheelView"

--- @class UIPopupSelectWheel : UIBase
UIPopupSelectWheel = Class(UIPopupSelectWheel, UIBase)

--- @return void
function UIPopupSelectWheel:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupSelectWheel:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupSelectWheelModel()
	self.view = UIPopupSelectWheelView(self.model, self.ctrl)
end

return UIPopupSelectWheel
