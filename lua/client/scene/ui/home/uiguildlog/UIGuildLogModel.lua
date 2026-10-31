
--- @class UIGuildLogModel : UIBaseModel
UIGuildLogModel = Class(UIGuildLogModel, UIBaseModel)

--- @return void
function UIGuildLogModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildLog, "guild_log")

	self.bgDark = true
end

