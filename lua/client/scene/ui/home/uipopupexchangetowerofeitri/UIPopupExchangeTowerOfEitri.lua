require "lua.client.scene.ui.home.uiPopupExchangeTowerOfEitri.UIPopupExchangeTowerOfEitriModel"
require "lua.client.scene.ui.home.uiPopupExchangeTowerOfEitri.UIPopupExchangeTowerOfEitriView"

--- @class UIPopupExchangeTowerOfEitri : UIBase
UIPopupExchangeTowerOfEitri = Class(UIPopupExchangeTowerOfEitri, UIBase)

--- @return void
function UIPopupExchangeTowerOfEitri:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupExchangeTowerOfEitri:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupExchangeTowerOfEitriModel()
	self.view = UIPopupExchangeTowerOfEitriView(self.model)
end

return UIPopupExchangeTowerOfEitri
