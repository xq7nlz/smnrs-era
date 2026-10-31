
--- @class UIMultiEvolveModel : UIBaseModel
UIMultiEvolveModel = Class(UIMultiEvolveModel, UIBaseModel)

--- @return void
function UIMultiEvolveModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMultiEvolve, "multi_evolve")

	self.bgDark = true
end

