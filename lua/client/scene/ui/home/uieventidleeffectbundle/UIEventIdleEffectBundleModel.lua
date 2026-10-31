
--- @class UIEventIdleEffectBundleModel : UIBaseModel
UIEventIdleEffectBundleModel = Class(UIEventIdleEffectBundleModel, UIBaseModel)

--- @return void
function UIEventIdleEffectBundleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventIdleEffectBundle, "ui_event_idle_effect_bundle")

	--- @type UIPopupType
	self.type = UIPopupType.NORMAL_POPUP

	self.bgDark = true
end

