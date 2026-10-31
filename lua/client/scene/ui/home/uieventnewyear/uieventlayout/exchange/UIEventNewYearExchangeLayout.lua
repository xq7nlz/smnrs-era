--- @class UIEventNewYearExchangeLayout : UIEventNewYearLayout
UIEventNewYearExchangeLayout = Class(UIEventNewYearExchangeLayout, UIEventNewYearLayout)

function UIEventNewYearExchangeLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil

    UIEventNewYearLayout.Ctor(self, view, tab, anchor)

    self.moneyTypeShow = MoneyType.GEM
    self.opCode = OpCode.EVENT_NEW_YEAR_BOX_BUY
    self.actionType = EventActionType.NEW_YEAR_GEM_BOX_BUY
end

function UIEventNewYearExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_exchange", self.anchor)
    UIEventNewYearLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventNewYearExchangeLayout:InitLocalization()
    UIEventNewYearLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_new_year_exchange_title")
end

function UIEventNewYearExchangeLayout:InitItemShow()
    --- @param obj GemBoxMidAutumnItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(exchangeData, self.eventModel:GetNumberBuy(self.actionType, exchangeData.id),
                function(number)
                    self.eventNewYearModel:AddNumberBuy(self.actionType, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.GemBoxNewYearItemView, onUpdateItem, onUpdateItem)
end

function UIEventNewYearExchangeLayout:InitButtonListener()

end

function UIEventNewYearExchangeLayout:OnShow()
    UIEventNewYearLayout.OnShow(self)
    --- @type EventNewYearModel
    self.eventNewYearModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
    self.listData = self.eventConfig:GetGemPackListConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventNewYearExchangeLayout:SetUpLayout()
    UIEventNewYearLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventNewYearExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(self.moneyTypeShow)
    self.moneyTableView:SetData(moneyList)
end

function UIEventNewYearExchangeLayout:OnHide()
    UIEventNewYearLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






