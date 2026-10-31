require "lua.client.scene.ui.home.uiEventSeasonal.UIEventSeasonalModel"
require "lua.client.scene.ui.home.uiEventSeasonal.UIEventSeasonalView"

--- @class UIEventSeasonal : UIBase
UIEventSeasonal = Class(UIEventSeasonal, UIBase)

--- @return void
function UIEventSeasonal:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventSeasonal:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventSeasonalModel()
	self.view = UIEventSeasonalView(self.model)
end

return UIEventSeasonal
