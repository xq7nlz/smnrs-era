--- @class UIGemPackLayout : UIEventBlackFridayLayout
UIGemPackLayout = Class(UIGemPackLayout, UIEventBlackFridayLayout)

--- @param view UIEventBlackFridayView
--- @param blackFridayTab BlackFridayTab
--- @param anchor UnityEngine_RectTransform
function UIGemPackLayout:Ctor(view, blackFridayTab, anchor)
    self.anchor = anchor
    self.blackFridayTab = blackFridayTab
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type UIGemPackLayoutConfig
    self.layoutConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_BLACK_FRIDAY)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIGemPackLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("black_friday_gem_pack", self.anchor)
    UIEventBlackFridayLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:InitItemShow()
    self:InitMoneyBars()
end

function UIGemPackLayout:InitLocalization()
    UIEventBlackFridayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("black_friday_gem_pack")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("black_friday_gem_pack_desc")
end

function UIGemPackLayout:SetUpLayout()
    UIEventBlackFridayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIGemPackLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeData
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(exchangeData, self.eventBlackFridayModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_GEM_PACK_BUY, exchangeData.id),
                function(number)
                    self.eventBlackFridayModel:AddNumberBuy(EventActionType.BLACK_FRIDAY_GEM_PACK_BUY, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.GemBoxBlackFridayItemView, onUpdateItem, onUpdateItem)
end

function UIGemPackLayout:OnShow()
    UIEventBlackFridayLayout.OnShow(self)
    self.listData = self.eventConfig:GetGemPackListConfig()
    self.uiScroll:Resize(self.listData:Count())
    self.moneyBarView:UpdateView()
    self.moneyBarView.config.iconMoney.transform.sizeDelta = U_Vector2(166,204)
end

function UIGemPackLayout:OnHide()
    UIEventBlackFridayLayout.OnHide(self)
    self.uiScroll:Hide()
end

function UIGemPackLayout:InitMoneyBars()
    self.moneyBarViewList = List()
    self.moneyList = List()
    self.moneyList:Add(MoneyType.GEM)
    for i = 1, self.moneyList:Count() do
        self.moneyBarView = MoneyBarLocalView(self.layoutConfig.moneyLocalBarInfo.transform)
        self.moneyBarView:SetIconData(self.moneyList:Get(i))
        self.moneyBarView:SetMoneyText(InventoryUtils.GetMoney(self.moneyList:Get(i)))
        self.moneyBarView.config.gameObject:SetActive(true)
        self.moneyBarViewList:Add(self.moneyBarView)
    end
end

