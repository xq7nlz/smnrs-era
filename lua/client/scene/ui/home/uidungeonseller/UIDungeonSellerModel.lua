
--- @class UIDungeonSellerModel : UIBaseModel
UIDungeonSellerModel = Class(UIDungeonSellerModel, UIBaseModel)

UIDungeonSellerModel.Child = 1
UIDungeonSellerModel.Woman = 2
UIDungeonSellerModel.Granny = 3

--- @return void
function UIDungeonSellerModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonSeller, "dungeon_seller")

	self.sellerId = nil -- 1 = Primary, 2 = Premium, 3 = Senior

	self.bgDark = true
end

