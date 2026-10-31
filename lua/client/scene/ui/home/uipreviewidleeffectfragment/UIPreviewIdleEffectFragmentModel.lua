
--- @class UIPreviewIdleEffectFragmentModel : UIBaseModel
UIPreviewIdleEffectFragmentModel = Class(UIPreviewIdleEffectFragmentModel, UIBaseModel)

--- @return void
function UIPreviewIdleEffectFragmentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewIdleEffectFragment, "ui_preview_idle_effect_fragment")
	self.bgDark = true
end

