require "lua.client.scene.ui.home.uiNewServerWeek3.UINewServerWeekModel3"
require "lua.client.scene.ui.home.uiNewServerWeek3.UINewServerWeekView3"

--- @class UINewServerWeek33 : UIBase
UINewServerWeek3 = Class(UINewServerWeek3, UIBase)

--- @return void
function UINewServerWeek3:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UINewServerWeek3:OnCreate()
	UIBase.OnCreate(self)
	self.model = UINewServerWeekModel3()
	self.view = UINewServerWeekView3(self.model)
end

return UINewServerWeek3
