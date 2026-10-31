--- @class UIEventQixiFestivalExchangeLayout : UIEventQixiFestivalLayout
UIEventQixiFestivalExchangeLayout = Class(UIEventQixiFestivalExchangeLayout, UIEventQixiFestivalLayout)

--- @param view UIEventQixiFestivalView
--- @param tab QixiFestivalTab
--- @param anchor UnityEngine_RectTransform
function UIEventQixiFestivalExchangeLayout:Ctor(view, tab, anchor)
    --- @type UIEventQixiFestivalExchangeLayout
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    UIEventQixiFestivalLayout.Ctor(self, view, tab, anchor)
end

function UIEventQixiFestivalExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("qixi_festival_exchange", self.anchor)
    UIEventQixiFestivalLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventQixiFestivalExchangeLayout:InitLocalization()
    UIEventQixiFestivalLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_qixi_festival_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_qixi_festival_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventQixiFestivalExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_QIXI_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.QIXI_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.QIXI_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventQixiFestivalExchangeLayout:OnShow()
    UIEventQixiFestivalLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventQixiFestivalExchangeLayout:SetUpLayout()
    UIEventQixiFestivalLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventQixiFestivalExchangeLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_QIXI_EXCHANGE_TICKET)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventQixiFestivalExchangeLayout:OnHide()
    UIEventQixiFestivalLayout.OnHide(self)
    self.uiScroll:Hide()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end






