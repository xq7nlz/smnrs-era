
--- @class UIEventMayDayModel : UIBaseModel
UIEventMayDayModel = Class(UIEventMayDayModel, UIBaseModel)

--- @return void
function UIEventMayDayModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventMayDay, "ui_event_may_day")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventMayDayModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(MayDayTab.GOLDEN_TIME)
	self.listSubEvent:Add(MayDayTab.BINGO)
	self.listSubEvent:Add(MayDayTab.QUEST)
	self.listSubEvent:Add(MayDayTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(MayDayTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(MayDayTab.SHOP)
end

