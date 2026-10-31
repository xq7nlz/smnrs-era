
--- @class UIEventNewYear2023Model : UIBaseModel
UIEventNewYear2023Model = Class(UIEventNewYear2023Model, UIBaseModel)

--- @return void
function UIEventNewYear2023Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventNewYear2023, "ui_event_new_year_2023")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventNewYear2023Model:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(NewYear2023Tab.GOLDEN_TIME)
	self.listSubEvent:Add(NewYear2023Tab.LUCKY_WISH)
	self.listSubEvent:Add(NewYear2023Tab.QUEST)
	self.listSubEvent:Add(NewYear2023Tab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(NewYear2023Tab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(NewYear2023Tab.SHOP)
end

