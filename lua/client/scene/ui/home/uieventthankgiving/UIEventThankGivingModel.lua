
--- @class UIEventThankGivingModel : UIBaseModel
UIEventThankGivingModel = Class(UIEventThankGivingModel, UIBaseModel)

--- @return void
function UIEventThankGivingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventThankGiving, "ui_event_thank_giving")
	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventThankGivingModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(ThankGivingTab.GOLDEN_TIME)
	self.listSubEvent:Add(ThankGivingTab.DICE)
	self.listSubEvent:Add(ThankGivingTab.QUEST)
	self.listSubEvent:Add(ThankGivingTab.EXCHANGE)
	if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
		self.listSubEvent:Add(ThankGivingTab.SPECIAL_OFFER)
	end
	--self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
	self.listSubEvent:Add(ThankGivingTab.SHOP)
end