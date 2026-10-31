--- @class UIEventBirthdayExchangeLayout : UIEventBirthdayLayout
UIEventBirthdayExchangeLayout = Class(UIEventBirthdayExchangeLayout, UIEventBirthdayLayout)

--- @param view UIEventHalloweenView
--- @param eventBirthdayTab EventBirthdayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayExchangeLayout:Ctor(view, eventBirthdayTab, anchor)
    --- @type UIEventBirthdayExchangeLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type EventActionType
    self.eventActionType = EventActionType.BIRTHDAY_BUNDLE_PURCHASE
    --- @type OpCode
    --self.opCode = OpCode.EVENT_BIRTHDAY_EXCHANGE-- bo tinh nang
    self.opCode = nil -- unused
    --- @type MoneyType
    self.moneyType = MoneyType.GEM
    UIEventBirthdayLayout.Ctor(self, view, eventBirthdayTab, anchor)
end

function UIEventBirthdayExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_exchange", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventBirthdayExchangeLayout:InitLocalization()
    UIEventBirthdayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_birthday_exchange_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_birthday_exchange_desc")
end

function UIEventBirthdayExchangeLayout:InitItemShow()
    --- @param obj ExchangeMultiItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        local packId = exchangeData.id
        obj:SetIconData(self.opCode, exchangeData, self.eventModel:GetNumberBuyOpCode(self.opCode, packId),
                function(number)
                    self.eventModel:AddNumberBuyOpCode(self.opCode, packId, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMultiItemView, onUpdateItem, onUpdateItem)
end

function UIEventBirthdayExchangeLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventBirthdayExchangeLayout:SetUpLayout()
    UIEventBirthdayLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventBirthdayExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(self.moneyType)
    self.moneyTableView:SetData(moneyList)
end

function UIEventBirthdayExchangeLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end