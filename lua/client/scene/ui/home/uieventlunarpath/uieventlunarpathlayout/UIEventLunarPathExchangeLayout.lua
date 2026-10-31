--- @class UIEventLunarPathExchangeLayout : UIEventLunarPathLayout
UIEventLunarPathExchangeLayout = Class(UIEventLunarPathExchangeLayout, UIEventLunarPathLayout)

--- @param view UIEventXmasView
--- @param tab XmasTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarPathExchangeLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listData = nil
    --- @type ItemsTableView
    self.moneyTableView = nil

    self.localizeRequireChap = ""
    UIEventLunarPathLayout.Ctor(self, view, tab, anchor)
end

function UIEventLunarPathExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_path_exchange", self.anchor)
    UIEventLunarPathLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventLunarPathExchangeLayout:InitLocalization()
    UIEventLunarPathLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_lunar_path_exchange_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_lunar_path_exchange_desc")
    self.localizeRequireChap = LanguageUtils.LocalizeCommon("require_chap_boss")
end

function UIEventLunarPathExchangeLayout:InitItemShow()
    --- @param obj ExchangeMidAutumnItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeEventConfig
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(OpCode.EVENT_LUNAR_NEW_YEAR_LUNAR_SHOP_EXCHANGE, exchangeData,
                self.eventModel:GetNumberBuy(EventActionType.LUNAR_PATH_SHOP_EXCHANGE,
                        exchangeData.id),
                function(number)
                    self.eventModel:AddNumberBuy(EventActionType.LUNAR_PATH_SHOP_EXCHANGE, exchangeData.id, number)
                end)
        if exchangeData.chapRequired ~= nil
                and ((self.eventModel.isInGuild == true and self.eventModel.eventLunarBossData.recentPassedChap < exchangeData.chapRequired)
                or (self.eventModel.isInGuild == false and exchangeData.chapRequired > 0)) then
            obj:ActiveMaskNoti(true, string.format(self.localizeRequireChap, exchangeData.chapRequired))
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.ExchangeMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventLunarPathExchangeLayout:InitButtonListener()

end

function UIEventLunarPathExchangeLayout:OnShow()
    UIEventLunarPathLayout.OnShow(self)
    self.listData = self.eventConfig:GetListExchangeChapBossConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventLunarPathExchangeLayout:SetUpLayout()
    UIEventLunarPathLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventLunarPathExchangeLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_LUNAR_NEW_FLAG)
    moneyList:Add(MoneyType.GEM)
    self.moneyTableView:SetData(moneyList)
end

function UIEventLunarPathExchangeLayout:OnHide()
    UIEventLunarPathLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end






