
--- @class UISelectTalentModel : UIBaseModel
UISelectTalentModel = Class(UISelectTalentModel, UIBaseModel)

--- @return void
function UISelectTalentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectTalent, "popup_select_talent")

	self.bgDark = true
end

