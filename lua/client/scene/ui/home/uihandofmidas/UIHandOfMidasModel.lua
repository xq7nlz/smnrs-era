
--- @class UIHandOfMidasModel : UIBaseModel
UIHandOfMidasModel = Class(UIHandOfMidasModel, UIBaseModel)

--- @return void
function UIHandOfMidasModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHandOfMidas, "hand_of_midas")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

