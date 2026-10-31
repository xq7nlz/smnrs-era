--- @class UIEventNewHeroExchangeLayout : UIEventNewHeroLayout
UIEventNewHeroExchangeLayout = Class(UIEventNewHeroExchangeLayout, UIEventNewHeroLayout)

--- @param view UIEventNewHeroView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroExchangeLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventExchangeMidAutumnLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    ---@type List<DiceSlotView>
    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_hero_exchange", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventNewHeroExchangeLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_new_hero_exchange_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_new_hero_exchange_desc")
end

function UIEventNewHeroExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_NEW_HERO_EXCHANGE, exchangeData, self.eventModel:GetNumberExchange(exchangeData.id),
                function(number)
                    self.eventModel:AddNumberExchange(exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventNewHeroExchangeLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)
    local bg = ResourceLoadUtils.LoadTexture("BannerNewHeroExchange", tostring(self.eventModel.timeData.dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgEvent.sprite = bg
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventNewHeroExchangeLayout:SetUpLayout()
    UIEventNewHeroLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventNewHeroExchangeLayout:ShowMoneyBar()
    --local moneyList = List()
    --moneyList:Add(MoneyType.EVENT_HALLOWEEN_PUMPKIN)
    --self.moneyTableView:SetData(moneyList)
end

function UIEventNewHeroExchangeLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






