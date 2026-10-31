
--- @class UISelectOrbPopupModel : UIBaseModel
UISelectOrbPopupModel = Class(UISelectOrbPopupModel, UIBaseModel)

--- @return void
function UISelectOrbPopupModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectOrbPopup, "popup_select_orb")
	self.bgDark = true

end

