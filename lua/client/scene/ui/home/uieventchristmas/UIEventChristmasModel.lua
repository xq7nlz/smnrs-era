
--- @class UIEventChristmasModel : UIBaseModel
UIEventChristmasModel = Class(UIEventChristmasModel, UIBaseModel)

--- @return void
function UIEventChristmasModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventChristmas, "ui_event_christmas")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventChristmasModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(ChristmasTab.ARENA)
	self.listSubEvent:Add(ChristmasTab.FEED_BEAST)
	self.listSubEvent:Add(ChristmasTab.QUEST)
	self.listSubEvent:Add(ChristmasTab.EXCHANGE)
	self.listSubEvent:Add(ChristmasTab.FESTIVAL_MARKET)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(ChristmasTab.SPECIAL_OFFER)
	end
end

