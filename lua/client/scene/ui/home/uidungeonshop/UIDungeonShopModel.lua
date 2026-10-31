
--- @class UIDungeonShopModel : UIBaseModel
UIDungeonShopModel = Class(UIDungeonShopModel, UIBaseModel)

--- @return void
function UIDungeonShopModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonShop, "dungeon_shop")

	self.bgDark = true
end

