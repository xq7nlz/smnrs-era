
--- @class UIDungeonCollectionBagModel : UIBaseModel
UIDungeonCollectionBagModel = Class(UIDungeonCollectionBagModel, UIBaseModel)

--- @return void
function UIDungeonCollectionBagModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonCollectionBag, "dungeon_collection_bag")

	self.bgDark = true
end

