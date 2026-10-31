
--- @class UIDungeonMonsterReviewModel : UIBaseModel
UIDungeonMonsterReviewModel = Class(UIDungeonMonsterReviewModel, UIBaseModel)

--- @return void
function UIDungeonMonsterReviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonMonsterReview, "dungeon_monster_view")

	self.bgDark = true
end

