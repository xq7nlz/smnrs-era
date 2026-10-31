require "lua.client.scene.ui.home.uiSmashPopup.UISmashPopupModel"
require "lua.client.scene.ui.home.uiSmashPopup.UISmashPopupView"

--- @class UISmashPopup : UIBase
UISmashPopup = Class(UISmashPopup, UIBase)

--- @return void
function UISmashPopup:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISmashPopup:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISmashPopupModel()
	self.view = UISmashPopupView(self.model)
end

return UISmashPopup
