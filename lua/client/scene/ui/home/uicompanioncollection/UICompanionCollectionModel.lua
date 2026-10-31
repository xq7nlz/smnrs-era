
--- @class UICompanionCollectionModel : UIBaseModel
UICompanionCollectionModel = Class(UICompanionCollectionModel, UIBaseModel)

--- @return void
function UICompanionCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UICompanionCollection, "companion_collection")

	self.bgDark = true
end

