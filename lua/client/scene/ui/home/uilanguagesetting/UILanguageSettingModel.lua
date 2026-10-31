
--- @class UILanguageSettingModel : UIBaseModel
UILanguageSettingModel = Class(UILanguageSettingModel, UIBaseModel)

--- @return void
function UILanguageSettingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UILanguageSetting, "language_setting")

	self.bgDark = true
end

