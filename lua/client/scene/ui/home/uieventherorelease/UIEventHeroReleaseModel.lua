
--- @class UIEventHeroReleaseModel : UIBaseModel
UIEventHeroReleaseModel = Class(UIEventHeroReleaseModel, UIBaseModel)

--- @return void
function UIEventHeroReleaseModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventHeroRelease, "ui_event_hero_release")

	self.listSubEvent = List()
end

function UIEventHeroReleaseModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventHeroReleaseTab.Overview)
	local eventOtherHeroPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
	if eventOtherHeroPopupModel ~= nil and eventOtherHeroPopupModel:IsOpening() then
		self.listSubEvent:Add(EventHeroReleaseTab.OverviewOtherHero)
	end
	self.listSubEvent:Add(EventHeroReleaseTab.DailyQuest)
	self.listSubEvent:Add(EventHeroReleaseTab.Collection)
	self.listSubEvent:Add(EventHeroReleaseTab.Bundle)
end