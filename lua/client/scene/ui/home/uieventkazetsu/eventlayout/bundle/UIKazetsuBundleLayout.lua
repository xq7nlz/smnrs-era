--- @class UIKazetsuBundleLayout : UIEventKazetsuLayout
UIKazetsuBundleLayout = Class(UIKazetsuBundleLayout, UIEventKazetsuLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIKazetsuBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_KAZETSU
    --- @type PackViewType
    self.packViewType = PackViewType.KAZETSU_BUNDLE
    UIEventKazetsuLayout.Ctor(self, view, tab, anchor)
end

function UIKazetsuBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("kazetsu_bundle", self.anchor)
    UIEventKazetsuLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIKazetsuBundleLayout:InitLocalization()
    UIEventKazetsuLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("kazetsu_store_des")
end

function UIKazetsuBundleLayout:InitItemShow()
    --- @param obj IapTilePackItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listData:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackItem, onUpdateItem, onUpdateItem)
end

function UIKazetsuBundleLayout:OnPurchaseSuccess()

end

function UIKazetsuBundleLayout:InitButtonListener()

end

function UIKazetsuBundleLayout:OnShow()
    UIEventKazetsuLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetKazetsuBundle():GetPack(self.eventModel.timeData.dataId).packDict
    self.uiScroll:Resize(self.listData:Count())
end


function UIKazetsuBundleLayout:SetUpLayout()
    UIEventKazetsuLayout.SetUpLayout(self)
end

function UIKazetsuBundleLayout:OnHide()
    UIEventKazetsuLayout.OnHide(self)
    self.uiScroll:Hide()
end
