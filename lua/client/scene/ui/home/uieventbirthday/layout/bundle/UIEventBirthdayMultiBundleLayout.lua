--- @class UIEventBirthdayMultiBundleLayout : UIEventBirthdayLayout
UIEventBirthdayMultiBundleLayout = Class(UIEventBirthdayMultiBundleLayout, UIEventBirthdayLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayMultiBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventBirthdayBundleConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type PackViewType
    self.packViewType = PackViewType.BIRTHDAY_BUNDLE
    UIEventBirthdayLayout.Ctor(self, view, tab, anchor)
end

function UIEventBirthdayMultiBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_multi_bundle", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventBirthdayMultiBundleLayout:InitLocalization()
    UIEventBirthdayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("birthday_bundle")
end

function UIEventBirthdayMultiBundleLayout:InitItemShow()
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
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackLargeItem, onUpdateItem, onUpdateItem)
end

function UIEventBirthdayMultiBundleLayout:OnPurchaseSuccess()
    self.view:CheckAllNotificationTab()
end

function UIEventBirthdayMultiBundleLayout:InitButtonListener()

end

function UIEventBirthdayMultiBundleLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetBirthdayBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.uiScroll:Resize(self.listData:Count())
end


function UIEventBirthdayMultiBundleLayout:SetUpLayout()
    UIEventBirthdayLayout.SetUpLayout(self)
end

function UIEventBirthdayMultiBundleLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self.uiScroll:Hide()
end
