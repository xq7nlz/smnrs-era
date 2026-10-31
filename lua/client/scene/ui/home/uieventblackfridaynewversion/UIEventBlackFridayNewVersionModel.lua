
--- @class UIEventBlackFridayNewVersionModel : UIBaseModel
UIEventBlackFridayNewVersionModel = Class(UIEventBlackFridayNewVersionModel, UIBaseModel)

--- @return void
function UIEventBlackFridayNewVersionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBlackFridayNewVersion, "ui_event_black_friday_new_version")
	self.bgDark = true
end

function UIEventBlackFridayNewVersionModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventBlackFridayNewVersionTab.SELECT_ITEM)
	self.listSubEvent:Add(EventBlackFridayNewVersionTab.SUPER_DEAL)
end

