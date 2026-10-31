--- @class UIEventNewYear2023ExchangeLayout : UIEventNewYear2023Layout
UIEventNewYear2023ExchangeLayout = Class(UIEventNewYear2023ExchangeLayout, UIEventNewYear2023Layout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventNewYear2023ExchangeLayout:Ctor(view, halloweenTab, anchor)
    --- @type UIEventNewYear2023ExchangeLayout
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    UIEventNewYear2023Layout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventNewYear2023ExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_2023_exchange", self.anchor)
    UIEventNewYear2023Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventNewYear2023ExchangeLayout:InitLocalization()
    UIEventNewYear2023Layout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_new_year_2023_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_new_year_2023_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventNewYear2023ExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_NEW_YEAR_2023_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.NEW_YEAR_2023_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.NEW_YEAR_2023_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventNewYear2023ExchangeLayout:OnShow()
    UIEventNewYear2023Layout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventNewYear2023ExchangeLayout:SetUpLayout()
    UIEventNewYear2023Layout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventNewYear2023ExchangeLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_NEW_YEAR_Z_TICKET)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventNewYear2023ExchangeLayout:OnHide()
    UIEventNewYear2023Layout.OnHide(self)
    self.uiScroll:Hide()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end






