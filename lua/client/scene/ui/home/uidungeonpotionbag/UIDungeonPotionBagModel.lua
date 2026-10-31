
--- @class UIDungeonPotionBagModel : UIBaseModel
UIDungeonPotionBagModel = Class(UIDungeonPotionBagModel, UIBaseModel)

--- @return void
function UIDungeonPotionBagModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonPotionBag, "dungeon_potion_bag")

	self.bgDark = false
end

