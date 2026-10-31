
--- @class UIGuildWarRegistrationModel : UIBaseModel
UIGuildWarRegistrationModel = Class(UIGuildWarRegistrationModel, UIBaseModel)

--- @return void
function UIGuildWarRegistrationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarRegistration, "guild_war_registration_phase")
	self.bgDark = true
end

