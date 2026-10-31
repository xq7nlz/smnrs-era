--- @class UIEventValentine2024ExchangeLayout : UIEventValentine2024Layout
UIEventValentine2024ExchangeLayout = Class(UIEventValentine2024ExchangeLayout, UIEventValentine2024Layout)

--- @param view UIEventValentine2024View
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventValentine2024ExchangeLayout:Ctor(view, halloweenTab, anchor)
    --- @type UIEventValentine2024ExchangeLayout
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    UIEventValentine2024Layout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventValentine2024ExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_2024_exchange", self.anchor)
    UIEventValentine2024Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventValentine2024ExchangeLayout:InitLocalization()
    UIEventValentine2024Layout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_valentine_2024_exchange_name")
    --- @type string
    local content = LanguageUtils.LocalizeCommon("event_valentine_2024_exchange_desc")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("shop"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("dice_title"))
    self.layoutConfig.localizeEventContent.text = content
end

function UIEventValentine2024ExchangeLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_VALENTINE_2024_EXCHANGE, exchangeData, self.eventModel:GetNumberBuy(EventActionType.VALENTINE_2024_EXCHANGE, exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.VALENTINE_2024_EXCHANGE, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventValentine2024ExchangeLayout:OnShow()
    UIEventValentine2024Layout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventValentine2024ExchangeLayout:SetUpLayout()
    UIEventValentine2024Layout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventValentine2024ExchangeLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_VALENTINE_TICKET)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventValentine2024ExchangeLayout:OnHide()
    UIEventValentine2024Layout.OnHide(self)
    self.uiScroll:Hide()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end






