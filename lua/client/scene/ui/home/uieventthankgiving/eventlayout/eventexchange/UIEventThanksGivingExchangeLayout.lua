--- @class UIEventThanksGivingExchangeLayout : UIEventThanksGivingLayout
UIEventThanksGivingExchangeLayout = Class(UIEventThanksGivingExchangeLayout, UIEventThanksGivingLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventThanksGivingExchangeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    ---@type List<DiceSlotView>
    UIEventThanksGivingLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventThanksGivingExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("thanks_giving_exchange", self.anchor)
    UIEventThanksGivingLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventThanksGivingExchangeLayout:InitLocalization()
    UIEventThanksGivingLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_thanks_giving_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_thanks_giving_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventThanksGivingExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_THANKS_GIVING_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.THANKS_GIVING_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.THANKS_GIVING_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventThanksGivingExchangeLayout:OnShow()
    UIEventThanksGivingLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventThanksGivingExchangeLayout:SetUpLayout()
    UIEventThanksGivingLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventThanksGivingExchangeLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.THANK_GIVING_PUMPKIN)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventThanksGivingExchangeLayout:OnHide()
    UIEventThanksGivingLayout.OnHide(self)
    self.uiScroll:Hide()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end






