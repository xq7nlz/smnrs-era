require "lua.client.scene.ui.home.uiCheckData.UICheckDataModel"
require "lua.client.scene.ui.home.uiCheckData.UICheckDataView"

--- @class UICheckData : UIBase
UICheckData = Class(UICheckData, UIBase)

--- @return void
function UICheckData:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UICheckData:OnCreate()
	UIBase.OnCreate(self)
	self.model = UICheckDataModel()
	self.view = UICheckDataView(self.model)
end

return UICheckData
