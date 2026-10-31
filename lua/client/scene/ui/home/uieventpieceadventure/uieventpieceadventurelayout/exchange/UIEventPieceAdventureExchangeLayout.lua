require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventPieceAdventureExchangeLayout : UIEventPieceAdventureLayout
UIEventPieceAdventureExchangeLayout = Class(UIEventPieceAdventureExchangeLayout, UIEventPieceAdventureLayout)

--- @param view UIEventView
function UIEventPieceAdventureExchangeLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventPieceAdventureExchangeLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventPieceAdventureLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventPieceAdventureExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_piece_adventure_exchange_layout", self.anchor)
    UIEventPieceAdventureLayout.InitLayoutConfig(self, inst)

    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventPieceAdventureExchangeLayout:InitLocalization()
    UIEventPieceAdventureLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_piece_adventure_exchange_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_piece_adventure_exchange_desc")
end

function UIEventPieceAdventureExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_PIECE_ADVENTURE_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.PIECE_ADVENTURE_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.PIECE_ADVENTURE_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventPieceAdventureExchangeLayout:OnShow()
    UIEventPieceAdventureLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventPieceAdventureExchangeLayout:SetUpLayout()
    UIEventPieceAdventureLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventPieceAdventureExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_PIECE_ADVENTURE_COIN)
    self.moneyTableView:SetData(moneyList)
end

function UIEventPieceAdventureExchangeLayout:OnHide()
    UIEventPieceAdventureLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end