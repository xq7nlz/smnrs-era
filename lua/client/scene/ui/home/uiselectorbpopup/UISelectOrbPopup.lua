require "lua.client.scene.ui.home.uiSelectOrbPopup.UISelectOrbPopupModel"
require "lua.client.scene.ui.home.uiSelectOrbPopup.UISelectOrbPopupView"

--- @class UISelectOrbPopup : UIBase
UISelectOrbPopup = Class(UISelectOrbPopup, UIBase)

--- @return void
function UISelectOrbPopup:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectOrbPopup:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectOrbPopupModel()
	self.view = UISelectOrbPopupView(self.model)
end

return UISelectOrbPopup
