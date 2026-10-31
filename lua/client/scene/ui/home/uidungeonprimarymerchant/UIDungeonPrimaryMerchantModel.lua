
--- @class UIDungeonPrimaryMerchantModel : UIBaseModel
UIDungeonPrimaryMerchantModel = Class(UIDungeonPrimaryMerchantModel, UIBaseModel)

--- @return void
function UIDungeonPrimaryMerchantModel:Ctor()

	UIBaseModel.Ctor(self, UIPopupName.UIDungeonPrimaryMerchant, "dungeon_primary_merchant")

	--- @type number
    self.sellerId = nil
	--- @type List <MarketItemInBound>
	self.itemList = nil

	self.bgDark = true
end

