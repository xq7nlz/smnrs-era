--- @class UIMidAutumnMarketLayout : UIEventMidAutumnLayout
UIMidAutumnMarketLayout = Class(UIMidAutumnMarketLayout, UIEventMidAutumnLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIMidAutumnMarketLayout:Ctor(view, tab, anchor)
    ---@type UIEventMidAutumnMarketConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_MID_AUTUMN_BUNDLE
    UIEventMidAutumnLayout.Ctor(self, view, tab, anchor)
end

function UIMidAutumnMarketLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_mid_autumn_festival_market_layout", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIMidAutumnMarketLayout:InitLocalization()
    UIEventMidAutumnLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_mid_autumn_market_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_mid_autumn_market_des")
end

function UIMidAutumnMarketLayout:InitItemShow()
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

function UIMidAutumnMarketLayout:OnPurchaseSuccess()

end

function UIMidAutumnMarketLayout:InitButtonListener()

end

function UIMidAutumnMarketLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetMidAutumn():GetPack(self.eventMidAutumnModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIMidAutumnMarketLayout:SetUpLayout()
    UIEventMidAutumnLayout.SetUpLayout(self)
end

function UIMidAutumnMarketLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    self.uiScroll:Hide()
end
