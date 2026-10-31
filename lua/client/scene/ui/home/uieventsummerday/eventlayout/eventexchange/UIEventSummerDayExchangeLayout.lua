--- @class UIEventSummerDayExchangeLayout : UIEventSummerDayLayout
UIEventSummerDayExchangeLayout = Class(UIEventSummerDayExchangeLayout, UIEventSummerDayLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventSummerDayExchangeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    ---@type List<DiceSlotView>
    UIEventSummerDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventSummerDayExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("summer_day_exchange", self.anchor)
    UIEventSummerDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventSummerDayExchangeLayout:InitLocalization()
    UIEventSummerDayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_summer_day_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_summer_day_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventSummerDayExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_SUMMER_DAY_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.SUMMER_DAY_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.SUMMER_DAY_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventSummerDayExchangeLayout:OnShow()
    UIEventSummerDayLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventSummerDayExchangeLayout:SetUpLayout()
    UIEventSummerDayLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventSummerDayExchangeLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SUMMER_EXCHANGE_TICKET)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventSummerDayExchangeLayout:OnHide()
    UIEventSummerDayLayout.OnHide(self)
    self.uiScroll:Hide()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end






