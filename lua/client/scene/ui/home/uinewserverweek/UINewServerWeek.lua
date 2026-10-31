require "lua.client.scene.ui.home.uiNewServerWeek.UINewServerWeekModel"
require "lua.client.scene.ui.home.uiNewServerWeek.UINewServerWeekView"

--- @class UINewServerWeek : UIBase
UINewServerWeek = Class(UINewServerWeek, UIBase)

--- @return void
function UINewServerWeek:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UINewServerWeek:OnCreate()
	UIBase.OnCreate(self)
	self.model = UINewServerWeekModel()
	self.view = UINewServerWeekView(self.model)
end

return UINewServerWeek
