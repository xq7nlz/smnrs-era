
--- @class UIGuildApplicationModel : UIBaseModel
UIGuildApplicationModel = Class(UIGuildApplicationModel, UIBaseModel)

--- @return void
function UIGuildApplicationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildApplication, "guild_application")

	self.bgDark = true
end

