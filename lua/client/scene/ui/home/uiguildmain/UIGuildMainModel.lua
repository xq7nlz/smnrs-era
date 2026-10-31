
--- @class UIGuildMainModel : UIBaseModel
UIGuildMainModel = Class(UIGuildMainModel, UIBaseModel)

--- @return void
function UIGuildMainModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildMain, "guild_main")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	--- @type GuildLevelUnit
	self.guildLevelUnit = nil
end
