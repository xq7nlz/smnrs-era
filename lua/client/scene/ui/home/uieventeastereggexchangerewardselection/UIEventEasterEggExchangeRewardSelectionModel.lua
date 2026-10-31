--- @class UIEventEasterEggExchangeRewardSelectionModel : UIBaseModel
UIEventEasterEggExchangeRewardSelectionModel = Class(UIEventEasterEggExchangeRewardSelectionModel, UIBaseModel)

--- @return void
function UIEventEasterEggExchangeRewardSelectionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventEasterEggExchangeRewardSelection, "ui_preview_tiger_path_fragment")
	self.bgDark = true
end

