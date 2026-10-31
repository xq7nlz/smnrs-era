
--- @class UIEventEasterDayModel : UIBaseModel
UIEventEasterDayModel = Class(UIEventEasterDayModel, UIBaseModel)

--- @return void
function UIEventEasterDayModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventEasterDay, "ui_event_easter_day")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventEasterDayModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(EasterDayTab.GOLDEN_TIME)
	self.listSubEvent:Add(EasterDayTab.DICE)
	self.listSubEvent:Add(EasterDayTab.QUEST)
	self.listSubEvent:Add(EasterDayTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(EasterDayTab.SPECIAL_OFFER)
	end
	self.listSubEvent:Add(EasterDayTab.SHOP)
end

