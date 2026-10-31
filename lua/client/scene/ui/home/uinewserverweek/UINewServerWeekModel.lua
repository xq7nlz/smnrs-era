require "lua.client.core.network.event.eventNewServerWeek.EventNewServerWeekModel"
--- @class UINewServerWeekModel: UIBaseModel
UINewServerWeekModel = Class(UINewServerWeekModel, UIBaseModel)

--- @return void
function UINewServerWeekModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UINewServerWeek, "ui_new_server")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end


