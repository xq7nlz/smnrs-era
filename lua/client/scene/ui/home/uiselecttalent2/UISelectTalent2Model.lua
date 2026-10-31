
--- @class UISelectTalent2Model : UIBaseModel
UISelectTalent2Model = Class(UISelectTalent2Model, UIBaseModel)

--- @return void
function UISelectTalent2Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectTalent2, "popup_select_talent_2")

	self.bgDark = true
end

