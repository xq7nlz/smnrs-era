--- @class UIEventSeasonalModel : UIBaseModel
UIEventSeasonalModel = Class(UIEventSeasonalModel, UIBaseModel)

--- @return void
function UIEventSeasonalModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventSeasonal, "ui_event_seasonal")

	self.listSubEvent = List()
	self.listSubEvent:Add(EventSeasonalTab.DAILY_CHECKIN)
	self.listSubEvent:Add(EventSeasonalTab.FIREWORK_CREATOR)
	self.listSubEvent:Add(EventSeasonalTab.FIREWORK_SHOP)
	self.listSubEvent:Add(EventSeasonalTab.FIREWORK_EXCHANGE)
	self.listSubEvent:Add(EventSeasonalTab.ROYAL_CHALLENGE)
	self.listSubEvent:Add(EventSeasonalTab.SUPPER_GIFT)
end