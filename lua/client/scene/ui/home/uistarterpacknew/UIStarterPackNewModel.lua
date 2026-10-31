
--- @class UIStarterPackNewModel : UIBaseModel
UIStarterPackNewModel = Class(UIStarterPackNewModel, UIBaseModel)

--- @return void
function UIStarterPackNewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIStarterPackNew, "starter_pack_new")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end

