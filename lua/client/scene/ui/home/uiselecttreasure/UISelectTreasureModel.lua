
--- @class UISelectTreasureModel : UIBaseModel
UISelectTreasureModel = Class(UISelectTreasureModel, UIBaseModel)

--- @return void
function UISelectTreasureModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectTreasure, "select_treasure_notification")

	self.bgDark = true
end

