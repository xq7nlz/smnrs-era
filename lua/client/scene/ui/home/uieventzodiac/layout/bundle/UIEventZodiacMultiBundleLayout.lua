--- @class UIEventZodiacMultiBundleLayout : UIEventZodiacLayout
UIEventZodiacMultiBundleLayout = Class(UIEventZodiacMultiBundleLayout, UIEventZodiacLayout)

--- @param view UIEventZodiacView
--- @param anchor UnityEngine_RectTransform
function UIEventZodiacMultiBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventZodiacBundleConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_ZODIAC
    --- @type PackViewType
    self.packViewType = PackViewType.ZODIAC_BUNDLE
    UIEventZodiacLayout.Ctor(self, view, tab, anchor)
end

function UIEventZodiacMultiBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("zodiac_multi_bundle", self.anchor)
    UIEventZodiacLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventZodiacMultiBundleLayout:InitLocalization()
    UIEventZodiacLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("zodiac_bundle")
end

function UIEventZodiacMultiBundleLayout:InitItemShow()
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
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackZodiacItem, onUpdateItem, onUpdateItem)
end

function UIEventZodiacMultiBundleLayout:OnPurchaseSuccess()
    self.view:CheckAllNotificationTab()
end

function UIEventZodiacMultiBundleLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventZodiacMultiBundleLayout:OnShow()
    UIEventZodiacLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetZodiacBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.uiScroll:Resize(self.listData:Count())
    self.anchor.gameObject:SetActive(true)
end


function UIEventZodiacMultiBundleLayout:SetUpLayout()
    UIEventZodiacLayout.SetUpLayout(self)
end

function UIEventZodiacMultiBundleLayout:OnHide()
    UIEventZodiacLayout.OnHide(self)
    self.uiScroll:Hide()
end
