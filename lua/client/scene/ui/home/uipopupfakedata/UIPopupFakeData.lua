require "lua.client.scene.ui.home.uiPopupFakeData.UIPopupFakeDataModel"
require "lua.client.scene.ui.home.uiPopupFakeData.UIPopupFakeDataView"

--- @class UIPopupFakeData : UIBase
UIPopupFakeData = Class(UIPopupFakeData, UIBase)

--- @return void
function UIPopupFakeData:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupFakeData:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupFakeDataModel()
	self.view = UIPopupFakeDataView(self.model, self.ctrl)
end

return UIPopupFakeData
