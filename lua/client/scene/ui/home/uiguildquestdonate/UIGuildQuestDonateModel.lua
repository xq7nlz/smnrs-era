
--- @class UIGuildQuestDonateModel : UIBaseModel
UIGuildQuestDonateModel = Class(UIGuildQuestDonateModel, UIBaseModel)

--- @return void
function UIGuildQuestDonateModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildQuestDonate, "event_guild_quest_donate")

	self.bgDark = true
end

