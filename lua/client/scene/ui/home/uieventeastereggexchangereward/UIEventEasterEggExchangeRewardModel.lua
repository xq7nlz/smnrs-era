--- @class UIEventEasterEggExchangeRewardModel : UIBaseModel
UIEventEasterEggExchangeRewardModel = Class(UIEventEasterEggExchangeRewardModel, UIBaseModel)

--- @return void
function UIEventEasterEggExchangeRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventEasterEggExchangeReward, "easter_egg_exchange")
end