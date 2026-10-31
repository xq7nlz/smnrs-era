
--- @class UIEggCombineModel : UIBaseModel
UIEggCombineModel = Class(UIEggCombineModel, UIBaseModel)

--- @return void
function UIEggCombineModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEggCombine, "egg_combine")
	self.bgDark = true
end

