require "lua.client.scene.ui.home.uiEventEasterEggExchangeRewardSelection.UIEventEasterEggExchangeRewardSelectionModel"
require "lua.client.scene.ui.home.uiEventEasterEggExchangeRewardSelection.UIEventEasterEggExchangeRewardSelectionView"

--- @class UIExchangeRewardSelection : UIBase
UIExchangeRewardSelection = Class(UIExchangeRewardSelection, UIBase)

--- @return void
function UIExchangeRewardSelection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIExchangeRewardSelection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventEasterEggExchangeRewardSelectionModel()
	self.view = UIEventEasterEggExchangeRewardSelectionView(self.model)
end

return UIExchangeRewardSelection
