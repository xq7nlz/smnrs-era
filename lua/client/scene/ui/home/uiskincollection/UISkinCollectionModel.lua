
--- @class UISkinCollectionModel : UIBaseModel
UISkinCollectionModel = Class(UISkinCollectionModel, UIBaseModel)

--- @return void
function UISkinCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISkinCollection, "skin_collection")

	self.bgDark = true
end

