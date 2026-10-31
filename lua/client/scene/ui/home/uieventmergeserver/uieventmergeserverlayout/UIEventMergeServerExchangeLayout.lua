--- @class UIEventMergeServerExchangeLayout : UIEventMergeServerLayout
UIEventMergeServerExchangeLayout = Class(UIEventMergeServerExchangeLayout, UIEventMergeServerLayout)

--- @param view UIEventMergeServerView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventMergeServerExchangeLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil

    self.localizeRequireChap = ""
    UIEventMergeServerLayout.Ctor(self, view, tab, anchor)
end

function UIEventMergeServerExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("merge_server_exchange", self.anchor)
    UIEventMergeServerLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventMergeServerExchangeLayout:InitLocalization()
    UIEventMergeServerLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_merge_server_exchange_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_merge_server_exchange_desc")
end

function UIEventMergeServerExchangeLayout:InitItemShow()
    --- @param obj ExchangeMidAutumnItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_SERVER_MERGE_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.SERVER_MERGE_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.SERVER_MERGE_EXCHANGE, exchangeData.id, number)
                    self.view:UpdateNotificationByTab(MergeServerTab.ACCUMULATION)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventMergeServerExchangeLayout:InitButtonListener()

end

function UIEventMergeServerExchangeLayout:OnShow()
    UIEventMergeServerLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end


function UIEventMergeServerExchangeLayout:SetUpLayout()
    UIEventMergeServerLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventMergeServerExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.GEM)
    self.moneyTableView:SetData(moneyList)
end

function UIEventMergeServerExchangeLayout:OnHide()
    UIEventMergeServerLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






