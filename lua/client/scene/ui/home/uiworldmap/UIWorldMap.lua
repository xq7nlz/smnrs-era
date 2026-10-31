require "lua.client.scene.ui.home.uiWorldMap.UIWorldMapModel"
require "lua.client.scene.ui.home.uiWorldMap.UIWorldMapView"

--- @class UIWorldMap : UIBase
UIWorldMap = Class(UIWorldMap, UIBase)

--- @return void
function UIWorldMap:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWorldMap:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWorldMapModel()
	self.view = UIWorldMapView(self.model, self.ctrl)
end

return UIWorldMap
