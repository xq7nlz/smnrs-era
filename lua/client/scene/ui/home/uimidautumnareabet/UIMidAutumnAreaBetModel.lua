
--- @class UIMidAutumnAreaBetModel : UIBaseModel
UIMidAutumnAreaBetModel = Class(UIMidAutumnAreaBetModel, UIBaseModel)

--- @return void
function UIMidAutumnAreaBetModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMidAutumnAreaBet, "popup_arena_bet_mid_autumn")
	self.bgDark = true
end

