--- @class UIEventTowerOfEitriBundleLayout : UIEventTowerOfEitriLayout
UIEventTowerOfEitriBundleLayout = Class(UIEventTowerOfEitriBundleLayout, UIEventTowerOfEitriLayout)

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventTowerOfEitriBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventTowerOfEitriBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type List
    self.listMoneyBar = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_TOWER_OF_EITRI_BUNDLE
    UIEventTowerOfEitriLayout.Ctor(self, view, tab, anchor)
end

function UIEventTowerOfEitriBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_tower_of_eitri_bundle_layout", self.anchor)
    UIEventTowerOfEitriLayout.InitLayoutConfig(self, inst)
    self:InitScrolls()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventTowerOfEitriBundleLayout:InitLocalization()
    UIEventTowerOfEitriLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("tower_of_eitri_bundle")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("tower_of_eitri_bundle_infor")
end

function UIEventTowerOfEitriBundleLayout:InitMoneyBar()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_DRAGON_TOWER_HAMMER)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_DRAGON_TOWER_COIN)
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

function UIEventTowerOfEitriBundleLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventTowerOfEitriBundleLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventTowerOfEitriBundleStore():GetCurrentPack()
    self.listPack = List()
    --- @param id number
    --- @param v ProductConfig
    for _, v in pairs(self.packOfProducts.packDict:GetItems()) do
        self.listPack:Add(v)
    end
end

function UIEventTowerOfEitriBundleLayout:InitScrolls()
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

function UIEventTowerOfEitriBundleLayout:OnPurchaseSuccess(id)
    self.uiScroll:Resize(self.listPack:Count())
end

function UIEventTowerOfEitriBundleLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_tower_of_eitri_bundle_info"))
    end)
end

function UIEventTowerOfEitriBundleLayout:OnShow()
    UIEventTowerOfEitriLayout.OnShow(self)
    self:InitPack()
    self:InitMoneyBar()
    self.uiScroll:Resize(self.listPack:Count())
    self.anchor.gameObject:SetActive(true)
end

function UIEventTowerOfEitriBundleLayout:SetUpLayout()
    UIEventTowerOfEitriLayout.SetUpLayout(self)
end

function UIEventTowerOfEitriBundleLayout:OnHide()
    UIEventTowerOfEitriLayout.OnHide(self)
    self.uiScroll:Hide()
    self:ReturnPoolMoneyBar()
end
