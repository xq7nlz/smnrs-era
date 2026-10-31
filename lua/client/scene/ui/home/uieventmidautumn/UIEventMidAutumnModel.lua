
--- @class UIEventMidAutumnModel : UIBaseModel
UIEventMidAutumnModel = Class(UIEventMidAutumnModel, UIBaseModel)

--- @return void
function UIEventMidAutumnModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventMidAutumn, "ui_event_mid_autumn")

	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventMidAutumnModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(MidAutumnTab.ARENA)
	self.listSubEvent:Add(MidAutumnTab.FEED_BEAST)
	self.listSubEvent:Add(MidAutumnTab.QUEST)
	self.listSubEvent:Add(MidAutumnTab.EXCHANGE)
	self.listSubEvent:Add(MidAutumnTab.FESTIVAL_MARKET)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(MidAutumnTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(MidAutumnTab.GEM_BOX)
	--self.listSubEvent:Add(MidAutumnTab.GOLDEN_TIME)
	--self.listSubEvent:Add(MidAutumnTab.DAILY_CHECK_IN)
end

