
--- @class UIEventSkinBundleModel : UIBaseModel
UIEventSkinBundleModel = Class(UIEventSkinBundleModel, UIBaseModel)

--- @return void
function UIEventSkinBundleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventSkinBundle, "ui_event_skin_bundle")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

