
--- @class UIEventQixiFestivalModel : UIBaseModel
UIEventQixiFestivalModel = Class(UIEventQixiFestivalModel, UIBaseModel)

--- @return void
function UIEventQixiFestivalModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventQixiFestival, "ui_event_qixi_festival")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventQixiFestivalModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(QixiFestivalTab.GOLDEN_TIME)
	self.listSubEvent:Add(QixiFestivalTab.LUCKY_WISH)
	self.listSubEvent:Add(QixiFestivalTab.QUEST)
	self.listSubEvent:Add(QixiFestivalTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(QixiFestivalTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(QixiFestivalTab.SHOP)
end
