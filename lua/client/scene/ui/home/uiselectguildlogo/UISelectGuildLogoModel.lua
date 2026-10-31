
--- @class UISelectGuildLogoModel : UIBaseModel
UISelectGuildLogoModel = Class(UISelectGuildLogoModel, UIBaseModel)

--- @return void
function UISelectGuildLogoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectGuildLogo, "select_guild_logo")
	--- @type number
	self.selectedLogoId = 1
	self.numberOfGuildLogo = 10

	self.bgDark = true
end

