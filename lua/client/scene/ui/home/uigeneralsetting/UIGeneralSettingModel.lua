
--- @class UIGeneralSettingModel : UIBaseModel
UIGeneralSettingModel = Class(UIGeneralSettingModel, UIBaseModel)

--- @return void
function UIGeneralSettingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGeneralSetting, "general_setting")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

