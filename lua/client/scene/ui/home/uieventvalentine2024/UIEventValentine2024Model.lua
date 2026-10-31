
--- @class UIEventValentine2024Model : UIBaseModel
UIEventValentine2024Model = Class(UIEventValentine2024Model, UIBaseModel)

--- @return void
function UIEventValentine2024Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventValentine2024, "ui_event_valentine_2024")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventValentine2024Model:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(Valentine2024Tab.GOLDEN_TIME)
	self.listSubEvent:Add(Valentine2024Tab.LUCKY_WISH)
	self.listSubEvent:Add(Valentine2024Tab.QUEST)
	self.listSubEvent:Add(Valentine2024Tab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(Valentine2024Tab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(Valentine2024Tab.SHOP)
end

