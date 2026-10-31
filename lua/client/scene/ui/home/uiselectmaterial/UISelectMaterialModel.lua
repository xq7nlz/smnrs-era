
--- @class UISelectMaterialModel : UIBaseModel
UISelectMaterialModel = Class(UISelectMaterialModel, UIBaseModel)

--- @return void
function UISelectMaterialModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectMaterial, "select_material")

	self.bgDark = true
end

