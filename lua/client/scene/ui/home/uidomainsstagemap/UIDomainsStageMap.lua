require "lua.client.scene.ui.home.uiDomainsStageMap.UIDomainsStageMapModel"
require "lua.client.scene.ui.home.uiDomainsStageMap.UIDomainsStageMapView"

--- @class UIDomainsStageMap : UIBase
UIDomainsStageMap = Class(UIDomainsStageMap, UIBase)

--- @return void
function UIDomainsStageMap:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainsStageMap:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainsStageMapModel()
	self.view = UIDomainsStageMapView(self.model)
end

return UIDomainsStageMap
