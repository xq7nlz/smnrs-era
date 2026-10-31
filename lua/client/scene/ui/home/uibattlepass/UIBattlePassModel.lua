
--- @class UIBattlePassModel : UIBaseModel
UIBattlePassModel = Class(UIBattlePassModel, UIBaseModel)

--- @return void
function UIBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBattlePass, "battle_pass")
	self.listLineReward = nil

end



