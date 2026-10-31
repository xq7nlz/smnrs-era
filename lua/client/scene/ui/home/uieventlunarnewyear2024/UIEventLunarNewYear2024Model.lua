
--- @class UIEventLunarNewYear2024Model : UIBaseModel
UIEventLunarNewYear2024Model = Class(UIEventLunarNewYear2024Model, UIBaseModel)

--- @return void
function UIEventLunarNewYear2024Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventLunarNewYear2024, "ui_event_lunar_new_year_2024")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventLunarNewYear2024Model:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(LunarNewYear2024Tab.GOLDEN_TIME)
	self.listSubEvent:Add(LunarNewYear2024Tab.BINGO)
	self.listSubEvent:Add(LunarNewYear2024Tab.QUEST)
	self.listSubEvent:Add(LunarNewYear2024Tab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(LunarNewYear2024Tab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(LunarNewYear2024Tab.SHOP)
end
