--- @class UIEventQixiFestivalShopLayout : UIEventQixiFestivalLayout
UIEventQixiFestivalShopLayout = Class(UIEventQixiFestivalShopLayout, UIEventQixiFestivalLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventQixiFestivalShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventQixiFestivalShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_QIXI_FESTIVAL_BUNDLE
    UIEventQixiFestivalLayout.Ctor(self, view, tab, anchor)
end

function UIEventQixiFestivalShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("qixi_festival_shop", self.anchor)
    UIEventQixiFestivalLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventQixiFestivalShopLayout:InitLocalization()
    UIEventQixiFestivalLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("qixi_festival_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_qixi_festival_shop_des")
end

function UIEventQixiFestivalShopLayout:InitItemShow()
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

function UIEventQixiFestivalShopLayout:OnPurchaseSuccess()

end

function UIEventQixiFestivalShopLayout:InitButtonListener()

end

function UIEventQixiFestivalShopLayout:OnShow()
    UIEventQixiFestivalLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventQixiFestivalBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventQixiFestivalShopLayout:SetUpLayout()
    UIEventQixiFestivalLayout.SetUpLayout(self)
end

function UIEventQixiFestivalShopLayout:OnHide()
    UIEventQixiFestivalLayout.OnHide(self)
    self.uiScroll:Hide()
end
