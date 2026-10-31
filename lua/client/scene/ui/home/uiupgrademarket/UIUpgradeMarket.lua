require "lua.client.scene.ui.home.uiUpgradeMarket.UIUpgradeMarketModel"
require "lua.client.scene.ui.home.uiUpgradeMarket.UIUpgradeMarketView"

--- @class UIUpgradeMarket : UIBase
UIUpgradeMarket = Class(UIUpgradeMarket, UIBase)

--- @return void
function UIUpgradeMarket:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIUpgradeMarket:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIUpgradeMarketModel()
    self.view = UIUpgradeMarketView(self.model, self.ctrl)
end

return UIUpgradeMarket
