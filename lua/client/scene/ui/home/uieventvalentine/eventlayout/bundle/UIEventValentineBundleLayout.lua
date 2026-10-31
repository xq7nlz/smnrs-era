--- @class UIEventValentineBundleLayout : UIEventValentineLayout
UIEventValentineBundleLayout = Class(UIEventValentineBundleLayout, UIEventValentineLayout)

--- @param view UIEventValentineView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventValentineBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil

    self.localizeRequireChap = ""
    UIEventValentineLayout.Ctor(self, view, tab, anchor)
end

function UIEventValentineBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_love_bundle", self.anchor)
    UIEventValentineLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

end

function UIEventValentineBundleLayout:InitLocalization()
    UIEventValentineLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("valentine_store_des")
end

function UIEventValentineBundleLayout:InitItemShow()
    --- @param obj IapTilePackItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listData:Get(dataIndex)
        obj:SetViewIconData(PackViewType.VALENTINE_BUNDLE, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackItem, onUpdateItem, onUpdateItem)
end

function UIEventValentineBundleLayout:OnPurchaseSuccess()

end

function UIEventValentineBundleLayout:InitButtonListener()

end

function UIEventValentineBundleLayout:OnShow()
    UIEventValentineLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetLoveBundleStore():GetPack(self.eventModel.timeData.dataId).packList
    self.uiScroll:Resize(self.listData:Count())
end


function UIEventValentineBundleLayout:SetUpLayout()
    UIEventValentineLayout.SetUpLayout(self)
end

function UIEventValentineBundleLayout:OnHide()
    UIEventValentineLayout.OnHide(self)
    self.uiScroll:Hide()
end






