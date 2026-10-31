
--- @class UIVipNewModel : UIBaseModel
UIVipNewModel = Class(UIVipNewModel, UIBaseModel)

--- @return void
function UIVipNewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIVipNew, "ui_vip")
end

