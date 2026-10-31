--- @class UIEventSeasonalFireworkShopLayout : UIEventSeasonalLayout
UIEventSeasonalFireworkShopLayout = Class(UIEventSeasonalFireworkShopLayout, UIEventSeasonalLayout)

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalFireworkShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventSeasonalFireworkShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SEASONAL
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_SEASONAL_BUNDLE
    --- @type UIEventSeasonalView
    self.view = view
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalFireworkShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_firework_shop_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
    self:InitScrolls()
end

function UIEventSeasonalFireworkShopLayout:InitLocalization()
    UIEventSeasonalLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_bundle")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("seasonal_bundle_infor")
end

function UIEventSeasonalFireworkShopLayout:InitMoneyBar()
    --- @type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_SEASONAL_MONEY)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SEASONAL_GUN_POWER)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventSeasonalFireworkShopLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventSeasonalFireworkShopLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventSeasonalBundleStore():GetCurrentPack()
    self.listPack = List()
    --- @param v ProductConfig
    for _, v in pairs(self.packOfProducts.packDict:GetItems()) do
        self.listPack:Add(v)
    end
end

function UIEventSeasonalFireworkShopLayout:InitScrolls()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type ProductConfig
        local productConfig = self.listPack:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, productConfig, function()
            self:OnPurchaseSuccess(productConfig.id)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.IapTilePackZodiacItem, onCreateItem)
end

function UIEventSeasonalFireworkShopLayout:OnPurchaseSuccess(id)
    self.uiScroll:Resize(self.listPack:Count())
    self.view:UpdateNotificationByTab(EventSeasonalTab.FIREWORK_SHOP)
end

function UIEventSeasonalFireworkShopLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
end

function UIEventSeasonalFireworkShopLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self:InitPack()
    self:InitMoneyBar()
    self.uiScroll:Resize(self.listPack:Count())
    self.anchor.gameObject:SetActive(true)
end

function UIEventSeasonalFireworkShopLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalFireworkShopLayout:OnHide()
    UIEventSeasonalLayout.OnHide(self)
    self.uiScroll:Hide()
    self:ReturnPoolMoneyBar()
end

--- @param onEventTimeEnded function
function UIEventSeasonalFireworkShopLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSeasonalFireworkShopLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalFireworkShopLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalFireworkShopLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalFireworkShopLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventSeasonalFireworkShopLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("time_next_day"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

