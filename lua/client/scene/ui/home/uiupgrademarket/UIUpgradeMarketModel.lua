
--- @class UIUpgradeMarketModel : UIBaseModel
UIUpgradeMarketModel = Class(UIUpgradeMarketModel, UIBaseModel)

--- @return void
function UIUpgradeMarketModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIUpgradeMarket, "market_upgrade_popup")

    --- @type List --<ItemIconData>
    self.resourceList = List()

    --- @type string
    self.textButton = nil

    self.bgDark = true
end

