--- @class UIBattlePassExchangeModel : UIBaseModel
UIBattlePassExchangeModel = Class(UIBattlePassExchangeModel, UIBaseModel)

--- @return void
function UIBattlePassExchangeModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBattlePassExchange, "battle_pass_exchange")
end