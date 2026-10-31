require "lua.client.scene.ui.home.uiDefenseMap.UIDefenseMapModel"
require "lua.client.scene.ui.home.uiDefenseMap.UIDefenseMapView"

--- @class UIDefenseMap : UIBase
UIDefenseMap = Class(UIDefenseMap, UIBase)

--- @return void
function UIDefenseMap:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDefenseMap:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDefenseMapModel()
	self.view = UIDefenseMapView(self.model)
end

return UIDefenseMap
