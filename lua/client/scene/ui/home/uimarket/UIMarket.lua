require "lua.client.scene.ui.home.uiMarket.UIMarketModel"
require "lua.client.scene.ui.home.uiMarket.UIMarketView"

--- @class UIMarket : UIBase
UIMarket = Class(UIMarket, UIBase)

--- @return void
function UIMarket:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMarket:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMarketModel()
	self.view = UIMarketView(self.model)
end

return UIMarket
