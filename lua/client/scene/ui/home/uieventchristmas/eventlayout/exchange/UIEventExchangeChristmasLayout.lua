require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventExchangeChristmasLayout : UIEventChristmasLayout
UIEventExchangeChristmasLayout = Class(UIEventExchangeChristmasLayout, UIEventChristmasLayout)

--- @param view UIEventView
function UIEventExchangeChristmasLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventExchangeChristmasLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventChristmasLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventExchangeChristmasLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("christmas_exchange_view", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)

    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventExchangeChristmasLayout:InitLocalization()
    UIEventChristmasLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_christmas_exchange_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_christmas_exchange_desc")
end

function UIEventExchangeChristmasLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_CHRISTMAS_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.CHRISTMAS_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventExchangeChristmasLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventExchangeChristmasLayout:SetUpLayout()
    UIEventChristmasLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventExchangeChristmasLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_CHRISTMAS_LIGHTENED_CANDLE)
    self.moneyTableView:SetData(moneyList)
end

function UIEventExchangeChristmasLayout:OnHide()
    UIEventChristmasLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end