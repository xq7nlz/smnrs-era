require "lua.client.core.network.event.eventNewServerWeek.EventNewServerWeekModel"
--- @class UINewServerWeekModel2: UIBaseModel
UINewServerWeekModel2 = Class(UINewServerWeekModel2, UIBaseModel)

--- @return void
function UINewServerWeekModel2:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UINewServerWeek2, "ui_new_server_2")
end


