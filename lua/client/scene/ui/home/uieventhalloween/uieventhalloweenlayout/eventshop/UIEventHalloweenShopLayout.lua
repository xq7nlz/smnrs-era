--- @class UIEventHalloweenShopLayout : UIEventHalloweenLayout
UIEventHalloweenShopLayout = Class(UIEventHalloweenShopLayout, UIEventHalloweenLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventHalloweenShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventHalloweenShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_HALLOWEEN_BUNDLE
    UIEventHalloweenLayout.Ctor(self, view, tab, anchor)
end

function UIEventHalloweenShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_shop", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventHalloweenShopLayout:InitLocalization()
    UIEventHalloweenLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_halloween_shop_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_halloween_shop_des")
end

function UIEventHalloweenShopLayout:InitItemShow()
    --- @param obj IapTilePackItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listDataMarket:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackZodiacItem, onUpdateItem, onUpdateItem)
end

function UIEventHalloweenShopLayout:OnPurchaseSuccess()

end

function UIEventHalloweenShopLayout:InitButtonListener()

end

function UIEventHalloweenShopLayout:OnShow()
    UIEventHalloweenLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetHalloween():GetPack(self.eventHalloweenModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventHalloweenShopLayout:SetUpLayout()
    UIEventHalloweenLayout.SetUpLayout(self)
end

function UIEventHalloweenShopLayout:OnHide()
    UIEventHalloweenLayout.OnHide(self)
    self.uiScroll:Hide()
end
