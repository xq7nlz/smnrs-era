--- @class UIEventHalloweenExchangeLayout : UIEventHalloweenLayout
UIEventHalloweenExchangeLayout = Class(UIEventHalloweenExchangeLayout, UIEventHalloweenLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventHalloweenExchangeLayout:Ctor(view, halloweenTab, anchor)
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    ---@type List<DiceSlotView>
    UIEventHalloweenLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventHalloweenExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_exchange", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventHalloweenExchangeLayout:InitLocalization()
    UIEventHalloweenLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_halloween_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_halloween_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventHalloweenExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_HALLOWEEN_EXCHANGE, exchangeData, self.eventHalloweenModel:GetNumberBuy(EventActionType.HALLOWEEN_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventHalloweenModel:AddNumberBuy(EventActionType.HALLOWEEN_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventHalloweenExchangeLayout:OnShow()
    UIEventHalloweenLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventHalloweenExchangeLayout:SetUpLayout()
    UIEventHalloweenLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventHalloweenExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_HALLOWEEN_PUMPKIN)
    self.moneyTableView:SetData(moneyList)
end

function UIEventHalloweenExchangeLayout:OnHide()
    UIEventHalloweenLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






