require "lua.client.scene.ui.home.uiNewServerWeek2.UINewServerWeekModel2"
require "lua.client.scene.ui.home.uiNewServerWeek2.UINewServerWeekView2"

--- @class UINewServerWeek2 : UIBase
UINewServerWeek2 = Class(UINewServerWeek2, UIBase)

--- @return void
function UINewServerWeek2:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UINewServerWeek2:OnCreate()
	UIBase.OnCreate(self)
	self.model = UINewServerWeekModel2()
	self.view = UINewServerWeekView2(self.model)
end

return UINewServerWeek2
