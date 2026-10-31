
--- @class UIEventSummerDayModel : UIBaseModel
UIEventSummerDayModel = Class(UIEventSummerDayModel, UIBaseModel)

--- @return void
function UIEventSummerDayModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventSummerDay, "ui_event_summer_day")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventSummerDayModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(SummerDayTab.GOLDEN_TIME)
	self.listSubEvent:Add(SummerDayTab.DICE)
	self.listSubEvent:Add(SummerDayTab.QUEST)
	self.listSubEvent:Add(SummerDayTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(SummerDayTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(SummerDayTab.SHOP)
end

