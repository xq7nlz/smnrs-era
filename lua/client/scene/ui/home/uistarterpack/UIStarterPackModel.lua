
--- @class UIStarterPackModel : UIBaseModel
UIStarterPackModel = Class(UIStarterPackModel, UIBaseModel)

--- @return void
function UIStarterPackModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIStarterPack, "starter_pack")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

