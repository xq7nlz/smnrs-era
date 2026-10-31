
--- @class UIDefenseMapModel : UIBaseModel
UIDefenseMapModel = Class(UIDefenseMapModel, UIBaseModel)

--- @return void
function UIDefenseMapModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDefenseMap, "defense_map")
end

