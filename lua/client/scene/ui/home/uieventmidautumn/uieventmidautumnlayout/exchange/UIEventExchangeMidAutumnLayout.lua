require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventExchangeMidAutumnLayout : UIEventMidAutumnLayout
UIEventExchangeMidAutumnLayout = Class(UIEventExchangeMidAutumnLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventExchangeMidAutumnLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventExchangeMidAutumnLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventExchangeMidAutumnLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("exchange_mid_autumn_view", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventExchangeMidAutumnLayout:InitLocalization()
    UIEventMidAutumnLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_midautumn_exchange_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_midautumn_exchange_desc")
end

function UIEventExchangeMidAutumnLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_MID_AUTUMN_EXCHANGE, exchangeData, self.eventMidAutumnModel:GetNumberBuy(EventActionType.MID_AUTUMN_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventMidAutumnModel:AddNumberBuy(EventActionType.MID_AUTUMN_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventExchangeMidAutumnLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventExchangeMidAutumnLayout:SetUpLayout()
    UIEventMidAutumnLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventExchangeMidAutumnLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_MID_AUTUMN_LIGHT_LANTERN)
    self.moneyTableView:SetData(moneyList)
end

function UIEventExchangeMidAutumnLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end