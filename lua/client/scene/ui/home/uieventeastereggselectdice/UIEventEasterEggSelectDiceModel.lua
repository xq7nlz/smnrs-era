--- @class UIEventEasterEggSelectDiceModel : UIBaseModel
UIEventEasterEggSelectDiceModel = Class(UIEventEasterEggSelectDiceModel, UIBaseModel)

--- @return void
function UIEventEasterEggSelectDiceModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventEasterEggSelectDice, "super_dice_popup")
end