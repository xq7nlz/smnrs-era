
--- @class UIEventBlossomDayModel : UIBaseModel
UIEventBlossomDayModel = Class(UIEventBlossomDayModel, UIBaseModel)

--- @return void
function UIEventBlossomDayModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBlossomDay, "ui_event_blossom_day")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventBlossomDayModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(BlossomDayTab.GOLDEN_TIME)
	self.listSubEvent:Add(BlossomDayTab.LUCKY_WISH)
	self.listSubEvent:Add(BlossomDayTab.QUEST)
	self.listSubEvent:Add(BlossomDayTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(BlossomDayTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(BlossomDayTab.SHOP)
end

