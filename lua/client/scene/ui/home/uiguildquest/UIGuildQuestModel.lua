--- @class UIGuildQuestModel : UIBaseModel
UIGuildQuestModel = Class(UIGuildQuestModel, UIBaseModel)

--- @return void
function UIGuildQuestModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildQuest, "event_guild_quest_popup")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type GuildLevelUnit
	self.guildLevelUnit = nil
end
