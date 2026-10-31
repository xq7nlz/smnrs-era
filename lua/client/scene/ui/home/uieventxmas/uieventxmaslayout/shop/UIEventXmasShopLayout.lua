--- @class UIEventXmasShopLayout : UIEventXmasLayout
UIEventXmasShopLayout = Class(UIEventXmasShopLayout, UIEventXmasLayout)

--- @param view UIEventXmasView
--- @param tab XmasTab
--- @param anchor UnityEngine_RectTransform
function UIEventXmasShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventXmasLayout.Ctor(self, view, tab, anchor)
end

function UIEventXmasShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("xmas_exchange", self.anchor)
    UIEventXmasLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventXmasShopLayout:InitLocalization()
    UIEventXmasLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_shop_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_xmas_exchange_desc")
end

function UIEventXmasShopLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_CHRISTMAS_EXCHANGE_RESOURCE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_RESOURCE_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.CHRISTMAS_RESOURCE_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventXmasShopLayout:InitButtonListener()

end

function UIEventXmasShopLayout:OnShow()
    UIEventXmasLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end


function UIEventXmasShopLayout:SetUpLayout()
    UIEventXmasLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventXmasShopLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_CHRISTMAS_CANDY_BAR)
    self.moneyTableView:SetData(moneyList)
end

function UIEventXmasShopLayout:OnHide()
    UIEventXmasLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






