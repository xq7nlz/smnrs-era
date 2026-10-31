
--- @class UIQuickBattleModel : UIBaseModel
UIQuickBattleModel = Class(UIQuickBattleModel, UIBaseModel)

--- @return void
function UIQuickBattleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIQuickBattle, "quick_battle")

	self.bgDark = true
end

