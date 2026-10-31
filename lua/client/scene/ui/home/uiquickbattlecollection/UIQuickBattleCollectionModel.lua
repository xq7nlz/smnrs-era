
--- @class UIQuickBattleCollectionModel : UIBaseModel
UIQuickBattleCollectionModel = Class(UIQuickBattleCollectionModel, UIBaseModel)

--- @return void
function UIQuickBattleCollectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIQuickBattleCollection, "quick_battle_collection")

	self.bgDark = true
end

