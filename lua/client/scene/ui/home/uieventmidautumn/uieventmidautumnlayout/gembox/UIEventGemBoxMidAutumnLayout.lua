require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventGemBoxMidAutumnLayout : UIEventMidAutumnLayout
UIEventGemBoxMidAutumnLayout = Class(UIEventGemBoxMidAutumnLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventGemBoxMidAutumnLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventGemBoxMidAutumnLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventGemBoxMidAutumnLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("gem_box_mid_autumn_view", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    self:InitItemShow()
    self:InitLocalization()
    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventGemBoxMidAutumnLayout:InitLocalization()
    UIEventMidAutumnLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_gem_box_name")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_gem_box_desc")
end

function UIEventGemBoxMidAutumnLayout:InitItemShow()
    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeData
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(exchangeData, self.eventMidAutumnModel:GetNumberBuy(EventActionType.MID_AUTUMN_GEM_BOX_BUY, exchangeData.id),
                function (number)
                    self.eventMidAutumnModel:AddNumberBuy(EventActionType.MID_AUTUMN_GEM_BOX_BUY, exchangeData.id, number)
                end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical , UIPoolType.GemBoxMidAutumnItemView, onUpdateItem, onUpdateItem)
end

function UIEventGemBoxMidAutumnLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self.listData = self.eventConfig:GetListGemBoxConfig()
    self.uiScroll:Resize(self.listData:Count())
end

function UIEventGemBoxMidAutumnLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    self.uiScroll:Hide()
    self.moneyTableView:Hide()
end

function UIEventGemBoxMidAutumnLayout:SetUpLayout()
    UIEventMidAutumnLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventGemBoxMidAutumnLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.GEM)
    self.moneyTableView:SetData(moneyList)
end