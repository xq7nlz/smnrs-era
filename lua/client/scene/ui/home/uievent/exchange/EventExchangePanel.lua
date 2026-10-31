---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiEvent.exchange.EventExchangePanelConfig"

--- @class EventExchangePanel : IconView
EventExchangePanel = Class(EventExchangePanel, IconView)

function EventExchangePanel:Ctor()
    --- @type EventExchangeModel
    self.eventPopupModel = nil
    self.dataConfig = nil
    --- @type UILoopScroll
    self.scrollItem = nil
    --- @type UILoopScroll
    self.scrollHero = nil
    --- @type UILoopScroll
    self.scroll = nil
    ---@type List
    self.listData = nil
    self.type = 1
    ---@type List
    self.listMoneyId = List()
    ---@type List
    self.listMoneyBar = List()
    IconView.Ctor(self)
end

function EventExchangePanel:SetPrefabName()
    self.prefabName = 'event_exchange'
    self.uiPoolType = UIPoolType.EventExchangePanel
end

--- @param transform UnityEngine_Transform
function EventExchangePanel:SetConfig(transform)
    --- @type EventExchangePanelConfig
    ---@type EventExchangePanelConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonHelp.gameObject:SetActive(false)
    --self.config.buttonHelp.onClick:AddListener(function ()
    --    self:OnClickHelpInfo()
    --end)

    --- @param obj ExchangeItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ExchangeData
        local exchangeData = self.listData:Get(index + 1)
        obj:SetIconData(exchangeData, self.eventPopupModel)
    end
    self.scrollItem = UILoopScroll(self.config.scrollVertical, UIPoolType.ExchangeItemView, onUpdateItem, onUpdateItem)
    self.scrollHero = UILoopScroll(self.config.scrollView, UIPoolType.ExchangeHeroView, onUpdateItem, onUpdateItem)
end

--- @return void
function EventExchangePanel:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo(string.format("event_exchange_info_%s", self.type))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @param eventPopupModel EventExchangeModel
function EventExchangePanel:SetData(eventPopupModel)
    self.eventPopupModel = eventPopupModel
    self.listData, self.type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(self.eventPopupModel.timeData.dataId)

    local isHero = true
    for _, exchangeData in ipairs(self.listData:GetItems()) do
        if exchangeData.listReward:Count() == 1 then
            ---@type RewardInBound
            local reward = exchangeData.listReward:Get(1)
            if reward.type ~= ResourceType.HeroFragment then
                isHero = false
                break
            end
        else
            isHero = false
            break
        end
    end

    if isHero then
        self.config.item:SetActive(false)
        self.config.hero:SetActive(true)
        self.scroll = self.scrollHero
        self.config.textEventName.text = EventTimeType.GetLocalize(EventTimeType.EVENT_EXCHANGE_QUEST, 1)
        self.config.eventContent.text = EventTimeType.GetInfoLocalize(EventTimeType.EVENT_EXCHANGE_QUEST, 1)
    else
        self.config.item:SetActive(true)
        self.config.hero:SetActive(false)
        self.scroll = self.scrollItem
    end

    self.scroll:Resize(self.listData:Count())
    if isHero then
        self.scroll:SetArrowLeftRight(self.config.left, self.config.right, nil, 3)
    end
    self.listMoneyId:Clear()
    ---@param exchangeData ExchangeData
    for _, exchangeData in pairs(self.listData:GetItems()) do
        if exchangeData.listRequirement:Count() == 0 and exchangeData.listMoney:Count() == 1 then
            ---@type ItemIconData
            local iconData = exchangeData.listMoney:Get(1)
            if self.listMoneyId:IsContainValue(iconData.itemId) == false then
                self.listMoneyId:Add(iconData.itemId)
            end
        end
    end
    self:ReturnPoolMoneyBar()
    for _, v in pairs(self.listMoneyId:GetItems()) do
        local moneyBar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.rootMoney)
        moneyBar:SetIconData(v)
        self.listMoneyBar:Add(moneyBar)
    end
    return isHero
end

function EventExchangePanel:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function EventExchangePanel:ReturnPool()
    IconView.ReturnPool(self)
    self.scroll:Hide()
    self:ReturnPoolMoneyBar()
end

return EventExchangePanel